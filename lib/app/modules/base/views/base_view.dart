import 'package:attendance/app/cores/core_images.dart';
import 'package:attendance/app/cores/core_styles.dart';
import 'package:attendance/app/modules/attendance/views/attendance_view.dart';
import 'package:attendance/app/modules/grafik/views/grafik_view.dart';
import 'package:attendance/app/modules/history/controllers/history_controller.dart';
import 'package:attendance/app/modules/history/views/history_view.dart';
import 'package:attendance/app/modules/home/views/home_view.dart';
import 'package:attendance/app/modules/setting/controllers/setting_controller.dart';
import 'package:attendance/app/modules/setting/views/setting_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../../../cores/core_colors.dart';
import '../../attendance/controllers/attendance_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/base_controller.dart';

class BaseView extends GetView<BaseController> {
  BaseView({Key? key}) : super(key: key);
  final BaseController baseController = Get.put(BaseController());
  final HomeController homeController = Get.put(HomeController());
  final AttendanceController attendanceController =
      Get.put(AttendanceController());

  final SettingController settingController = Get.put(SettingController());
  final HistoryController historyController = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Image.asset(CoreImages.backTopRight),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(CoreImages.backBotImages),
          ),
          Obx((() => Container(
              child: controller.count.value == 0
                  ? HomeView()
                  : controller.count.value == 1
                      ? GrafikView()
                      : controller.count.value == 2
                          ? HistoryView()
                          : SettingView()))),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 30, left: 16, right: 16),
              width: double.infinity,
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Attendance',
                    style: CoreStyles.uTitle,
                  ),
                  SvgPicture.asset(
                    "assets/icons/settings.svg",
                    color: CoreColor.kHintTextColor,
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 80,
              child: _tabItem(),
            ),
          ),
        ],
      ),
    );
  }

  _tabItem() {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(25)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 1,
              child: _listMenu("assets/icons/home-filled.svg", 0, "home")),
          Expanded(
              flex: 1,
              child:
                  _listMenu("assets/icons/fingerprint.svg", 1, "attendance")),
          Expanded(
              flex: 1,
              child:
                  _listMenu("assets/icons/bookmark-filled.svg", 2, "history")),
          Expanded(
              flex: 1,
              child: _listMenu("assets/icons/settings.svg", 3, "setting")),
        ],
      ),
    );
  }

  _listMenu(String title, int index, String menu) {
    return Obx((() => GestureDetector(
          onTap: () {
            controller.setIndex(index);
          },
          child: Container(
            height: 60,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    title,
                    color: controller.count.value == index
                        ? CoreColor.primary
                        : CoreColor.kHintTextColor,
                    height: 30,
                  ),
                  Text(
                    menu,
                    style: TextStyle(
                      fontSize: 12,
                      color: controller.count.value == index
                          ? CoreColor.primary
                          : CoreColor.kHintTextColor,
                    ),
                  )
                ],
              ),
            ),
          ),
        )));
  }
}
