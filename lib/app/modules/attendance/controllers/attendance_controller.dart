import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'dart:ui' as ui;

import 'package:attendance/app/cores/core_constants.dart';
import 'package:attendance/app/data/models/offices_model.dart';
import 'package:attendance/app/data/models/user_model.dart';
import 'package:attendance/app/data/services/attendance_service.dart';
import 'package:attendance/app/data/services/office_services.dart';
import 'package:attendance/app/data/services/user_services.dart';
import 'package:attendance/app/modules/auth/controllers/authentication_manager.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

enum Status { none, running, stopped, paused }

class AttendanceController extends GetxController {
  Rx<Status> status = Status.running.obs;
  final AuthenticationManager _authenticationManager =
      Get.put(AuthenticationManager());

  final count = 0.obs;
  RxDouble latPos = 0.0.obs;
  RxDouble lngPos = 0.0.obs;
  RxDouble zoomPos = 17.0.obs;
  RxString address = "...".obs;
  RxString clockIn = "...".obs;
  RxString clockOut = "...".obs;

  // Map<CircleId, Circle> circles = <CircleId, Circle>{}.obs;
  // Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;

  List<CircleMarker> circles = <CircleMarker>[].obs;
  List<Marker> markers = <Marker>[].obs;
  // the user's initial location and current location
// as it moves

  late CameraController cameraController;
  late XFile? ximage;

  RxString imagePath = ''.obs;

  double userLat = 0.0;
  double userLng = 0.0;

  RxString absenLabel = "Pilih Absen".obs;
  RxString absenId = "0".obs;

  RxList<Absen> listAbsen = <Absen>[].obs;

  RxDouble officeRadius = 0.0.obs;
  RxInt distanceToOffice = 10000.obs;
  RxString statusUser = "wfo".obs;
  RxBool isMocked = true.obs;

  final String TAG = "attendance";

  @override
  void onInit() async {
    super.onInit();

    status.value = Status.running;

    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    print('[$TAG] isMocked ${pos.isMocked}');
    isMocked.value = pos.isMocked;

    double userLatitude = Get.arguments[0];
    double userLongitude = Get.arguments[1];

    userLat = userLatitude;
    userLng = userLongitude;

    print("$TAG user location  lat $userLatitude, long $userLongitude");

    OfficeModel model = await getOffice();
    UserModel userModel = await getUserModel();

    // listAbsen.value = userModel.absenCategory!.absens!;
    var day = DateFormat("EEEE", "id_ID")
        .format(DateTime.now().subtract(Duration(days: 0)));
    print(day);
    print(days[day]);

    List<Absen> absens = userModel.absenCategory!.absens!
        .where((element) => int.parse(element.days!) == days[day])
        .toList();

    listAbsen.value = absens;

    if (absens.isNotEmpty) {
      clockIn.value = absens.first.begin!;
      clockOut.value = absens.last.begin!;
    } else {
      clockIn.value = '-';
      clockOut.value = '-';
    }

    officeRadius.value = double.parse(model.radius!);

    var officeSplit = model.location!.split(',');

    print('$TAG office Split $officeSplit');

    latPos.value = double.parse(officeSplit[0]);
    lngPos.value = double.parse(officeSplit[1]);
    addCircleFM(double.parse(officeSplit[0]), double.parse(officeSplit[1]));
    addMarkerFM(double.parse(officeSplit[0]), double.parse(officeSplit[1]), 0,
        Colors.deepOrange);

    addMarkerFM(userLatitude, userLongitude, 1, Colors.deepPurple);

    UserModel user = await getUser();
    statusUser.value = user.status!;

    // addCircleFM();
    // addMarkerFM(double.parse(latPos.value), lngPos.value, 0, Colors.deepOrange);

    // Position position = await getGeoLocationPosition();
    // addMarkerFM(userLatitude, userLongitude, 1, Colors.deepPurple);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(userLatitude, userLongitude);
    print(placemarks);
    Placemark place = placemarks[0];

    print('[$TAG], $place');

    double distanceD = calculateDistance(
        double.parse(officeSplit[0]), double.parse(officeSplit[1]));

    distanceToOffice.value = (distanceD * 1000).round();

    if (kDebugMode) {
      print(
          "[$TAG], ${(distanceD * 1000).round()} M, kantor radius ${model.radius}");
    }

    var loc =
        '${place.name}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}';
    print('[$TAG], $loc');
    address.value = loc;

    status.value = Status.none;

    await initCamera();
  }

  Future<void> initCamera() async {
    var cameras = await availableCameras();
    cameraController = CameraController(cameras[1], ResolutionPreset.medium);
    await cameraController.initialize();
  }

  getImage() async {
    ximage = await cameraController.takePicture();
    imagePath.value = ximage!.path;
  }

  @override
  void onReady() {
    super.onReady();
    print('on Ready');
  }

  @override
  void onClose() {
    super.onClose();
    print('on Close');
  }

  void increment() => count.value++;
  double calculateDistance(lat1, lon1) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((userLat - lat1) * p) / 2 +
        c(lat1 * p) * c(userLat * p) * (1 - c((userLng - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  addCircleFM(double lat, double lng) {
    const circleId = "circleIdValFM";
    final circle = CircleMarker(
        point: LatLng(lat, lng),
        color: Colors.red.withOpacity(0.2),
        borderColor: Colors.deepOrange,
        borderStrokeWidth: 2,
        useRadiusInMeter: true,
        radius: officeRadius.value // 2000 meters | 2 km
        );

    // circles[0] = circle;
    circles.insert(0, circle);
  }

  addMarkerFM(double latitude, double longitude, int index, Color color) async {
    final marker = Marker(
        width: 100,
        height: 100,
        point: LatLng(latitude, longitude),
        builder: (ctx) => Icon(
              Icons.pin_drop_rounded,
              color: color,
            ));

    markers.insert(index, marker);
  }

  Future<Uint8List> getBytesFromAsset(
      {required String path, required int width}) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<Position> getGeoLocationPosition() async {
    status.value = Status.running;
    address.value = '...';

    print('[$TAG] getGeoLocationPosition');
    count.value = 0;

    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    print('[$TAG] isMocked ${pos.isMocked}');

    isMocked.value = pos.isMocked;

    print('[$TAG] position $pos');

    markers.removeAt(1);
    addMarkerFM(pos.latitude, pos.longitude, 1, Colors.deepPurple);

    userLat = pos.latitude;
    userLng = pos.longitude;

    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    // print(placemarks);
    Placemark place = placemarks[0];
    print('[$TAG], $place');

    var loc =
        '${place.name}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}';
    print('[$TAG], $loc');
    address.value = loc;

    status.value = Status.none;

    double distanceD = calculateDistance(latPos.value, lngPos.value);

    distanceToOffice.value = (distanceD * 1000).round();

    if (kDebugMode) {
      print("[$TAG], ${(distanceD * 1000).round()} M");
    }

    return pos;
  }

  Future<OfficeModel> getOffice() async {
    status.value = Status.running;

    OfficeModel model = await OfficeService()
        .fetchOfficesByUserId(_authenticationManager.getToken()!);

    status.value = Status.stopped;

    return model;
  }

  Future<String> attendanceStore() async {
    status.value = Status.running;
    // File file = File(imagePath.value);

    // print(file);

    await AttendanceService().attendanceStore(File(imagePath.value),
        _authenticationManager.getToken()!, '$userLat,$userLng', absenId.value);
    status.value = Status.stopped;

    return "";
  }

  Future<UserModel> getUser() async {
    return UserService().fetchUserByUserNip(_authenticationManager.getToken()!);
  }

  Future<UserModel> getUserModel() async {
    return await UserService()
        .fetchUserByUserNip(_authenticationManager.getToken()!);
  }
}
