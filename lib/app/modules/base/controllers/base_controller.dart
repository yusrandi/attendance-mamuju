import 'package:attendance/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';

class BaseController extends GetxController {
  RxInt count = 0.obs;
  AppUpdateInfo? _updateInfo;

  final String TAG = "Base";

  @override
  void onInit() async {
    super.onInit();

    await checkForUpdate();
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
  void setIndex(index) => count.value = index;

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      _updateInfo = info;

      if (_updateInfo?.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate()
            .catchError((e) => Get.snackbar("SIKEREN", e.toString()));
      }
      print("$TAG $info");
    }).catchError((e) {
      Get.snackbar("SIKEREN", e.toString());
    });
  }
}
