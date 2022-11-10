import 'package:get/get.dart';

import '../controllers/selfi_controller.dart';

class SelfiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelfiController>(
      () => SelfiController(),
    );
  }
}
