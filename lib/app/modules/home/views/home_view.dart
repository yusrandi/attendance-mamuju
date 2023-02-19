import 'package:attendance/app/cores/core_colors.dart';
import 'package:attendance/app/cores/core_constants.dart';
import 'package:attendance/app/cores/core_images.dart';
import 'package:attendance/app/data/models/offices_model.dart';
import 'package:attendance/app/data/models/user_model.dart';
import 'package:attendance/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../cores/core_styles.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final HomeController homeController = Get.find();
  @override
  Widget build(BuildContext context) {
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
          Container(
            padding: const EdgeInsets.all(16),
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat("HH:mm", "id_ID").format(DateTime.now()),
                        style: CoreStyles.uTitle.copyWith(
                            color: CoreColor.kTextColor, fontSize: 46),
                      ),
                      Text(
                        DateFormat("EEEE, d MMMM yyyy", "id_ID")
                            .format(DateTime.now()),
                        style: CoreStyles.uSubTitle,
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                          onTap: () {
                            // homeController.increment();
                            Get.toNamed(Routes.ATTENDANCE, arguments: [
                              homeController.latPos.value,
                              homeController.lngPos.value
                            ]);
                          },
                          child: Obx(
                            () => Container(
                              width: 250,
                              height: 250,
                              decoration: BoxDecoration(
                                gradient: homeController.count.value == 1
                                    ? CoreColor.linearGradient
                                    : CoreColor.linearGradientEnd,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 5), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset(CoreImages.fingerLottie,
                                      width: 100, height: 100),
                                  Text(
                                    "CLOCK ${homeController.count.value == 0 ? 'IN' : 'OUT'}",
                                    style: CoreStyles.uSubTitle
                                        .copyWith(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          )),
                      const SizedBox(height: 16),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.home_work_outlined,
                              color: Colors.grey),
                          const SizedBox(width: 16),
                          Obx(() => Text(
                                homeController.office.value,
                                maxLines: 1,
                                style: Theme.of(context).textTheme.labelLarge,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Icon(
                          Icons.access_alarms_rounded,
                          color: CoreColor.primary,
                        ),
                        Obx(
                          () => Text(
                            homeController.clockIn.value,
                            style: CoreStyles.uSubTitle.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                        Text(
                          "Jam Masuk",
                          style: CoreStyles.uContent,
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Icon(
                          Icons.access_alarms_rounded,
                          color: CoreColor.primary,
                        ),
                        Obx(
                          () => Text(
                            homeController.clockOut.value,
                            style: CoreStyles.uSubTitle.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                        Text(
                          "Jam Pulang",
                          style: CoreStyles.uContent,
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 120)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
