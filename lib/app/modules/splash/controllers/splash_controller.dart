import 'package:get/get.dart';

import '../../auth/controllers/authentication_manager.dart';

class SplashController extends GetxController {
  // final AuthenticationManager _authManager = Get.put(AuthenticationManager());

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();

    // _authManager.login('111');
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
}
