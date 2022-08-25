import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../cores/core_images.dart';
import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  SettingView({Key? key}) : super(key: key);
  final SettingController settingController = Get.find();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Image.asset(
            CoreImages.backTopImages,
            width: 250,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            child: Image.asset(
              CoreImages.backBotImages,
              height: 130,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Center(
          child: Text("This is Settingview"),
        ),
      ],
    ));
  }
}
