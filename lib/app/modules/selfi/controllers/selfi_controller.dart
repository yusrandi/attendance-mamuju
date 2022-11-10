import 'package:camera/camera.dart';
import 'package:get/get.dart';

class SelfiController extends GetxController {
  late CameraController cameraController;

  final count = 0.obs;
  @override
  void onInit() async {
    super.onInit();

    await initCamera();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    cameraController.dispose();
  }

  void increment() => count.value++;

  Future<void> initCamera() async {
    var cameras = await availableCameras();
    cameraController = CameraController(cameras[1], ResolutionPreset.medium);
    await cameraController.initialize();
  }
}
