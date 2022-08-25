import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt count = 0.obs;
  @override
  void onInit() {
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

  void increment() {
    count.value = count.value == 0 ? 1 : 0;
  }
}
