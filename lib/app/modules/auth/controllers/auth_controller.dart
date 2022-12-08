import 'dart:convert';
import 'dart:io';

import 'package:attendance/app/cores/core_strings.dart';
import 'package:attendance/app/routes/app_pages.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  FirebaseAuth auth = FirebaseAuth.instance;
  String verificationIdReeceived = "";
  String phoneNumberResult = "";
  String phoneId = "";

  late final AuthenticationManager _authManager =
      Get.put(AuthenticationManager());
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

  verifyPhoneNumber(String phoneNumber) {
    status.value = Status.running;
    count.value = 1;
    phoneNumberResult = phoneNumber;

    auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 5),
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
      // verificationCompleted: (phoneAuthCredential) async {
      //   await auth.signInWithCredential(phoneAuthCredential).then((value) => {
      //         print('you logged in succesfully'),

      //         // Get.offAndToNamed(Routes.OTP, arguments: verificationIdReeceived)
      //       });
      // },
      verificationFailed: (error) {
        print(error.message);
        sendSnackbar(error.message.toString());
        status.value = Status.none;
      },
      codeSent: (verificationId, forceResendingToken) {
        status.value = Status.none;
        verificationIdReeceived = verificationId;

        // Get.toNamed(Routes.OTP, arguments: verificationId);
      },
      codeAutoRetrievalTimeout: (verificationId) {
        // count.value = 0;
      },
    );
  }

  sendSnackbar(String msg) {
    Get.snackbar(
      CoreStrings.appName,
      msg,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  verifCode(String smsCode) async {
    status.value = Status.running;

    PhoneAuthCredential authCredential = PhoneAuthProvider.credential(
        verificationId: verificationIdReeceived, smsCode: smsCode);

    try {
      await auth.signInWithCredential(authCredential).then((value) => {
            status.value = Status.none,
            print('you are logged in successfully'),
            count.value = 2,
            loginUser(phoneNumberResult, phoneId)
          });
    } on PlatformException catch (e) {
      if (e.message!.contains(
          'The sms verification code used to create the phone auth credential is invalid')) {
        sendSnackbar("verif code is invalid");
      } else if (e.message!.contains('The sms code has expired')) {
        sendSnackbar('verif code has expired');
      }
    }
  }

  Future<String> loginUser(String phone, String device) async {
    print('Phone $phoneNumberResult, device $device');
    status.value = Status.running;
    var _response = await http.post(Uri.parse(Api().loginUrl), body: {
      "phone": phone,
      "device": device,
    });

    status.value = Status.none;

    var data = json.decode(_response.body);
    print(data['responsecode']);
    if (data['responsecode'] == '1') {
      UserModel user = UserModel.fromJson(json.decode(_response.body)['data']);

      // login(user.id.toString());
      _authManager.login(user.nip.toString());
      await Get.offAndToNamed(Routes.HOME);
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
