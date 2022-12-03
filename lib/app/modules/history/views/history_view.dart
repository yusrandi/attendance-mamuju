import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:get/get.dart';

import '../../../cores/core_colors.dart';
import '../../../cores/core_images.dart';
import '../../../cores/core_styles.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  HistoryView({Key? key}) : super(key: key);

  final HistoryController historyController = Get.find();

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
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: index == 0
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
                                  color: index == 0
                                      ? CoreColor.primary
                                      : Colors.white),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${index + 1 * 10} ",
                                    style: CoreStyles.uTitle.copyWith(
                                        fontSize: 20,
                                        color: index != 0
                                            ? Colors.black
                                            : Colors.white),
                                  ),
                                  Text(
                                    "Sen",
                                    style: CoreStyles.uTitle.copyWith(
                                        fontSize: 20,
                                        color: index != 0
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
                                        color: index != 0
                                            ? Colors.black
                                            : Colors.white),
                                  ),
                                  Text(
                                    "08:00",
                                    style: CoreStyles.uSubTitle.copyWith(
                                        color: index != 0
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
                                        color: index != 0
                                            ? Colors.black
                                            : Colors.white),
                                  ),
                                  Text(
                                    "14:00",
                                    style: CoreStyles.uSubTitle.copyWith(
                                        color: index != 0
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
                    itemCount: 11),
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
          GestureDetector(
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
          GestureDetector(
            onTap: () {
              if (historyController.count.value + 1 <
                  historyController.listMonth.length) {
                historyController.increment();
              }
            },
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
