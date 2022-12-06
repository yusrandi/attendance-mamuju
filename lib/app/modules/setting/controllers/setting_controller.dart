import 'package:attendance/app/data/models/user_model.dart';
import 'package:attendance/app/data/services/user_services.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../auth/controllers/authentication_manager.dart';

class SettingController extends GetxController {
  RxInt count = 7.obs;

  final AuthenticationManager _authManager = Get.put(AuthenticationManager());

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

  Future<UserModel> getUser() async {
    return UserService().fetchUserByUserNip(_authManager.getToken()!);
  }

  logOut() {
    _authManager.logOut();
    Get.offAllNamed(Routes.SPLASH);
  }
}
