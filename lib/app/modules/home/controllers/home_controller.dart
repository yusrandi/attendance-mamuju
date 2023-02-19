import 'package:attendance/app/cores/core_constants.dart';
import 'package:attendance/app/data/models/user_model.dart';
import 'package:attendance/app/data/services/user_services.dart';
import 'package:get/get.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../../data/models/offices_model.dart';
import '../../../data/services/office_services.dart';
import '../../auth/controllers/authentication_manager.dart';

class HomeController extends GetxController {
  final String TAG = "HomeController";
  RxInt count = 0.obs;

  RxString address = "...".obs;
  RxDouble latPos = 0.0.obs;
  RxDouble lngPos = 0.0.obs;

  RxString clockIn = '...'.obs;
  RxString clockOut = '...'.obs;
  RxString office = '...'.obs;

  final AuthenticationManager _authManager = Get.put(AuthenticationManager());

  @override
  void onInit() async {
    super.onInit();

    print('User Phone ${_authManager.getToken()}');
    Position position = await getGeoLocationPosition();
    count.value = 1;
    print(
        "[$TAG], Location Lat: ${position.latitude} , Long: ${position.longitude} ");

    latPos.value = position.latitude;
    lngPos.value = position.longitude;

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    // print(placemarks);
    Placemark place = placemarks[0];
    print('[$TAG], $place');

    var loc =
        '${place.name}, ${place.subLocality}, ${place.locality}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}';
    print('[$TAG], $loc');

    address.value = loc;

    UserModel model = await getUserByNip();

    office.value = model.office!.namaInstansi!;

    var day = DateFormat("EEEE", "id_ID")
        .format(DateTime.now().add(Duration(days: 0)));
    print(day);
    print(days[day]);

    List<Absen> absens = model.absenCategory!.absens!
        .where((element) => int.parse(element.days!) == days[day])
        .toList();

    if (absens.isNotEmpty) {
      clockIn.value = absens.first.begin!;
      clockOut.value = absens.last.end!;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() {
    count.value = count.value == 0 ? 1 : 0;
  }

  Future<OfficeModel> getOffice() async {
    print("User Token ${_authManager.getToken()!}");
    OfficeModel model =
        await OfficeService().fetchOfficesByUserId(_authManager.getToken()!);

    return model;
  }

  Future<UserModel> getUserByNip() async {
    return UserService().fetchUserByUserNip(_authManager.getToken()!);
  }

  Future<Position> getGeoLocationPosition() async {
    print('[$TAG], _getGeoLocationPosition');
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
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
