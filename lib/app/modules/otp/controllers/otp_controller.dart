// import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

enum Status { none, running, stopped, paused }

class OtpController extends GetxController {
  Rx<Status> status = Status.none.obs;

  final count = 0.obs;

  // FirebaseAuth auth = FirebaseAuth.instance;
  String verifIdReceived = "";

  @override
  void onInit() {
    String verifId = Get.arguments;

    verifIdReceived = verifId;

    super.onInit();
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
  // verifCode(String smsCode) async {
  //   status.value = Status.running;

  //   PhoneAuthCredential authCredential = PhoneAuthProvider.credential(
  //       verificationId: verifIdReceived, smsCode: smsCode);

  //   await auth.signInWithCredential(authCredential).then((value) =>
  //       {status.value = Status.none, print('you are logged in successfully')});
  // }
}
