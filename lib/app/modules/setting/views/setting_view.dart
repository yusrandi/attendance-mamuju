import 'package:attendance/app/cores/core_colors.dart';
import 'package:attendance/app/data/models/user_model.dart';
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(CoreImages.logoMamujuImages, height: 100),
              FutureBuilder<UserModel>(
                future: settingController.getUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    UserModel user = snapshot.data!;

                    return Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Text(user.name!,
                              style: Theme.of(context).textTheme.titleLarge),
                          Text(user.nip!,
                              style: Theme.of(context).textTheme.titleLarge),
                          Text(user.office!.namaInstansi!,
                              style: Theme.of(context).textTheme.caption),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(user.phone!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(color: Colors.deepPurple)),
                              const SizedBox(width: 16),
                              Text(user.status!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(color: Colors.deepOrange)),
                            ],
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () => settingController.logOut(),
                            child: Container(
                              width: size.width * 0.5,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: CoreColor.primary),
                              child: Center(
                                child: Text('Keluar',
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .titleSmall),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
