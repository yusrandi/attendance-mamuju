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
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 100),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Profile',
                              style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 16),
                          userTitle(user, context),
                          const Divider(thickness: 1.5),
                          const SizedBox(height: 16),
                          userDetail(
                              'Nama Instansi',
                              user.office!.namaInstansi!,
                              context,
                              Icons.work_rounded),
                          const SizedBox(height: 16),
                          userDetail('Nomor Hp', user.phone!, context,
                              Icons.perm_phone_msg_sharp),
                          const SizedBox(height: 16),
                          userDetail(
                              'Status Bekerja',
                              user.status! == 'wfo'
                                  ? 'WFO'
                                  : 'Petugas Lapangan',
                              context,
                              Icons.supervised_user_circle),
                          const SizedBox(height: 16),
                          const Divider(thickness: 1.5),
                          const SizedBox(width: 16),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () => settingController.logOut(),
                            child: Container(
                              width: size.width,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Row(
                                children: [
                                  const Icon(Icons.logout_rounded,
                                      color: Colors.grey),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('KELUAR',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge),
                                    ],
                                  ),
                                ],
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

  Row userDetail(
      String title, String value, BuildContext context, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: Theme.of(context).textTheme.labelLarge),
            Text(title, style: Theme.of(context).textTheme.caption),
          ],
        ),
      ],
    );
  }

  Row userTitle(UserModel user, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(CoreImages.logoMamujuImages),
          radius: 25,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.name!, style: Theme.of(context).textTheme.titleLarge),
            Text(user.nip!, style: Theme.of(context).textTheme.caption),
          ],
        )
      ],
    );
  }
}
