import 'package:attendance/app/cores/core_colors.dart';
import 'package:attendance/app/cores/core_images.dart';
import 'package:attendance/app/cores/core_strings.dart';
import 'package:attendance/app/cores/core_styles.dart';
import 'package:attendance/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../../auth/controllers/authentication_manager.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  SplashView({Key? key}) : super(key: key);
  final AuthenticationManager _authManager = Get.put(AuthenticationManager());
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, bottom: 50, top: 50),
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  CoreStrings.appName,
                  style: CoreStyles.uTitle.copyWith(color: Colors.black),
                ),
                Text(CoreStrings.welcomeTitle,
                    style: CoreStyles.uSubTitle.copyWith(color: Colors.black)),
              ],
            ),
            Expanded(child: Lottie.asset(CoreImages.attendanceLottie)),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  CoreStrings.appName,
                  style: CoreStyles.uTitle.copyWith(color: Colors.black),
                ),
                Text(
                  "Fast & easy way to record and track attendance of\nYour Employees",
                  style: CoreStyles.uSubTitle.copyWith(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Builder(
                builder: (context) {
                  final GlobalKey<SlideActionState> _key = GlobalKey();
                  return SlideAction(
                    key: _key,
                    onSubmit: () {
                      if (_authManager.getToken() == null) {
                        Get.offAndToNamed(Routes.AUTH);
                      } else {
                        print(_authManager.getToken());
                        Get.offAndToNamed(Routes.BASE);
                      }
                      // Future.delayed(Duration(seconds: 1),
                      //     () => Get.offAndToNamed(Routes.AUTH));
                    },
                    alignment: Alignment.centerRight,
                    sliderButtonIcon: Icon(Icons.arrow_forward_ios_rounded,
                        color: CoreColor.primary),
                    innerColor: Colors.white,
                    outerColor: CoreColor.primary,
                    borderRadius: 16,
                    child: const Text(
                      ' Swipe Right to SIGN IN',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
