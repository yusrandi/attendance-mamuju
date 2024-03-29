import 'package:attendance/app/data/models/presensi_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../cores/core_colors.dart';
import '../../../cores/core_images.dart';
import '../../../cores/core_styles.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  HistoryView({Key? key}) : super(key: key);

  final HistoryController historyController = Get.find();
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    print("days ${now}");
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
            child: SizedBox(
              width: double.infinity,
              child: Image.asset(
                CoreImages.backBotImages,
                height: 130,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 100),
              monthWidget(),
              const SizedBox(height: 16),
              Expanded(
                  child: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      Presensi presensi = historyController.listPresensi[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: index + 1 == now.day
                                ? CoreColor.primarySoft
                                : Colors.black12),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32),
                                  color: index + 1 == now.day
                                      ? CoreColor.primary
                                      : Colors.white),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    presensi.tanggal!,
                                    style: CoreStyles.uTitle.copyWith(
                                        fontSize: 20,
                                        color: index + 1 != now.day
                                            ? Colors.black
                                            : Colors.white),
                                  ),
                                  Text(
                                    presensi.hari!,
                                    style: CoreStyles.uTitle.copyWith(
                                        fontSize: 20,
                                        color: index + 1 != now.day
                                            ? Colors.black
                                            : Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Clock In ",
                                    style: CoreStyles.uSubTitle.copyWith(
                                        color: index + 1 != now.day
                                            ? Colors.black
                                            : Colors.white),
                                  ),
                                  Text(
                                    presensi.masuk! == '-'
                                        ? presensi.leaves!
                                        : presensi.masuk!,
                                    style: CoreStyles.uSubTitle.copyWith(
                                        color: index + 1 != now.day
                                            ? CoreColor.kTextColor
                                            : Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Clock Out ",
                                    style: CoreStyles.uSubTitle.copyWith(
                                        color: index + 1 != now.day
                                            ? Colors.black
                                            : Colors.white),
                                  ),
                                  Text(
                                    presensi.pulang! == '-'
                                        ? presensi.leaves!
                                        : presensi.pulang!,
                                    style: CoreStyles.uSubTitle.copyWith(
                                        color: index + 1 != now.day
                                            ? CoreColor.kTextColor
                                            : Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemCount: historyController.listPresensi.length),
              )),
              const SizedBox(height: 50),
            ],
          ),
        ],
      ),
    );
  }

  Obx monthWidget() {
    return Obx(
      () => Row(
        children: [
          Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: false,
            child: GestureDetector(
              onTap: () {
                if (historyController.count.value - 1 >= 0) {
                  historyController.decrement();
                }
              },
              child: Container(
                  height: 45,
                  width: 45,
                  child: Center(child: Icon(Icons.arrow_back_ios_new_rounded))),
            ),
          ),
          Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  if (historyController.count.value - 1 >= 0) {
                    historyController.decrement();
                  }
                },
                child: Center(
                    child: Text(
                  historyController.count.value - 1 >= 0
                      ? historyController
                          .listMonth[historyController.count.value - 1].label
                          .substring(0, 3)
                      : "",
                  style: CoreStyles.uTitle
                      .copyWith(color: CoreColor.kHintTextColor, fontSize: 20),
                )),
              )),
          Expanded(
              flex: 2,
              child: Center(
                  child: Text(
                historyController
                    .listMonth[historyController.count.value].label,
                style: CoreStyles.uTitle,
              ))),
          Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () => historyController.increment(),
                child: Center(
                    child: Text(
                  historyController.count.value + 1 <
                          historyController.listMonth.length
                      ? historyController
                          .listMonth[historyController.count.value + 1].label
                          .substring(0, 3)
                      : "",
                  style: CoreStyles.uTitle
                      .copyWith(color: CoreColor.kHintTextColor, fontSize: 20),
                )),
              )),
          Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: false,
            child: GestureDetector(
              onTap: () {
                if (historyController.count.value + 1 <
                    historyController.listMonth.length) {
                  historyController.increment();
                }
              },
              child: Container(
                  height: 45,
                  width: 45,
                  child: Center(child: Icon(Icons.arrow_forward_ios_rounded))),
            ),
          ),
        ],
      ),
    );
  }
}
