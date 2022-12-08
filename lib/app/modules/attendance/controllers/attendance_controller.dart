import 'dart:async';
import 'dart:io';

import 'dart:ui' as ui;

import 'package:attendance/app/data/models/offices_model.dart';
import 'package:attendance/app/data/services/attendance_service.dart';
import 'package:attendance/app/data/services/office_services.dart';
import 'package:attendance/app/modules/auth/controllers/authentication_manager.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

enum Status { none, running, stopped, paused }

class AttendanceController extends GetxController {
  final String TAG = "AttendanceController";

  Rx<Status> status = Status.running.obs;
  final AuthenticationManager _authenticationManager =
      Get.put(AuthenticationManager());

  final count = 0.obs;
  RxString latPos = "".obs;
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

  @override
  void onInit() async {
    super.onInit();

    double userLatitude = Get.arguments[0];
    double userLongitude = Get.arguments[1];

    userLat = userLatitude;
    userLng = userLongitude;

    print("lat $userLatitude, long $userLongitude");

    OfficeModel model = await getOffice();

    clockIn.value = model.absens!.first.begin!;
    clockOut.value = model.absens!.last.begin!;

    var officeSplit = model.location!.split(',');
    latPos.value = officeSplit[0];
    lngPos.value = double.parse(officeSplit[1]);
    addCircleFM(double.parse(officeSplit[0]), double.parse(officeSplit[1]));
    addMarkerFM(double.parse(officeSplit[0]), double.parse(officeSplit[1]), 0,
        Colors.deepOrange);

    addMarkerFM(userLatitude, userLongitude, 1, Colors.deepPurple);

    // addCircleFM();
    // addMarkerFM(double.parse(latPos.value), lngPos.value, 0, Colors.deepOrange);

    // Position position = await getGeoLocationPosition();
    // addMarkerFM(userLatitude, userLongitude, 1, Colors.deepPurple);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(userLatitude, userLongitude);
    print(placemarks);
    Placemark place = placemarks[0];
    print('[$TAG], $place');

    var loc =
        '${place.name}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}';
    print('[$TAG], $loc');
    address.value = loc;

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

  // addCircle() {
  //   final CircleId circleId = CircleId("circleIdVal");

  //   final Circle circle = Circle(
  //     circleId: circleId,
  //     consumeTapEvents: true,
  //     strokeColor: CoreColor.primary,
  //     fillColor: Colors.transparent,
  //     strokeWidth: 3,
  //     center: LatLng(latPos, lngPos.value),
  //     radius: 50,
  //   );

  //   circles[circleId] = circle;
  // }

  addCircleFM(double lat, double lng) {
    const circleId = "circleIdValFM";
    final circle = CircleMarker(
        point: LatLng(lat, lng),
        color: Colors.red.withOpacity(0.2),
        borderColor: Colors.deepOrange,
        borderStrokeWidth: 2,
        useRadiusInMeter: true,
        radius: 100 // 2000 meters | 2 km
        );

    // circles[0] = circle;
    circles.insert(0, circle);
  }

  // addMarker(double latitude, double longitude, String id, String path) async {
  //   final Uint8List customMarker = await getBytesFromAsset(
  //       path: path, //paste the custom image path
  //       width: 150 // size of custom image as marker
  //       );

  //   MarkerId markerId = MarkerId("markerIdVal$id");

  //   final Marker marker = Marker(
  //     markerId: markerId,
  //     position: LatLng(
  //       latitude,
  //       longitude,
  //     ),
  //     icon: BitmapDescriptor.fromBytes(customMarker),
  //     infoWindow: InfoWindow(title: "Office", snippet: 'Jl. Our Office'),
  //   );

  //   markers[markerId] = marker;
  // }

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
        _authenticationManager.getToken()!, '$userLat,$userLng');
    status.value = Status.stopped;

    return "";
  }
}
