import 'dart:convert';
import 'dart:io';

import 'package:attendance/app/cores/core_strings.dart';
import 'package:attendance/app/routes/app_pages.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../cores/core_colors.dart';
import '../../../data/config/api.dart';
import '../../../data/models/user_model.dart';
import 'authentication_manager.dart';

enum Status { none, running, stopped, paused }

class AuthController extends GetxController {
  final count = 0.obs;
  Rx<Status> status = Status.none.obs;
  RxBool passwordVisible = false.obs;

  // FirebaseAuth auth = FirebaseAuth.instance;
  String verificationIdReeceived = "";
  String phoneNumberResult = "";
  String phoneId = "";

  late final AuthenticationManager _authManager =
      Get.put(AuthenticationManager());

  final String TAG = "auth";
  @override
  void onInit() async {
    super.onInit();

    phoneId = (await _getId())!;

    print(phoneId);
    // loginUser(phoneNumber, phoneId);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  sendSnackbar(String msg) {
    Get.snackbar(
      CoreStrings.appName,
      msg,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<String> loginUser(String username, String password) async {
    print('$TAG Phone $phoneNumberResult, device $phoneId');
    status.value = Status.running;
    var _response = await http.post(Uri.parse(Api().loginUrl), body: {
      "username": username,
      "password": password,
      "device": phoneId,
    });

    status.value = Status.none;
    print('$TAG res ${_response.body}');

    var data = json.decode(_response.body);
    print('$TAG data $data');
    Get.snackbar(CoreStrings.appName, "${data['responsemsg']}",
        backgroundColor: CoreColor.whiteSoft,
        duration: const Duration(seconds: 2));

    if (data['responsecode'] == '1') {
      UserModel user = UserModel.fromJson(json.decode(_response.body)['user']);

      // login(user.id.toString());
      _authManager.login(user.nip.toString());
      await Get.offAllNamed(Routes.BASE);
    } else {
      Get.snackbar(CoreStrings.appName, "${data['responsemsg']}",
          backgroundColor: CoreColor.whiteSoft,
          duration: const Duration(seconds: 2));
    }

    return _response.body;
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id; // unique ID on Android
    }
  }
}
