import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../cores/core_colors.dart';
import '../../../cores/core_images.dart';
import '../../../cores/core_strings.dart';
import '../../../cores/core_styles.dart';
import '../../../routes/app_pages.dart';
import '../controllers/otp_controller.dart';

class OtpView extends GetView<OtpController> {
  OtpView({Key? key}) : super(key: key);

  final OtpController _otpController = Get.put(OtpController());
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final userOtp = TextEditingController();

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
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    CoreStrings.appName,
                    style: CoreStyles.uTitle.copyWith(color: Colors.black),
                  ),
                  Text(CoreStrings.welcomeTitle,
                      style:
                          CoreStyles.uSubTitle.copyWith(color: Colors.black)),
                ],
              ),
            ),
            Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: double.infinity,
                          child: Lottie.asset(CoreImages.attendanceLottie,
                              height: 200)),
                      Text(
                        "OTP Code",
                        style: CoreStyles.uTitle,
                      ),
                      const SizedBox(height: (16)),
                      emailField(
                          userOtp, TextInputType.text, 'OTP Code', Icons.code),
                      const SizedBox(height: (8)),
                      const Text(
                        "button next will be appear if otp code is valid",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: (16)),
                      GestureDetector(
                        onTap: () async {
                          // await _otpController.verifCode(userOtp.text);
                          // Get.toNamed(Routes.OTP);
                          // if (_formKey.currentState!.validate()) {
                          //   _formKey.currentState!.save();

                          //   var email = _userEmail.text.trim();
                          //   var password = _userPass.text.trim();

                          //   print(email);
                          //   // await authController.loginUser(email, password);
                          //   KeyboardUtil.hideKeyboard(context);
                          // }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              color: CoreColor.primary,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                              child: Obx(
                            () => _otpController.status.value == Status.running
                                ? loading()
                                : Text(
                                    "Continue",
                                    style: CoreStyles.uSubTitle
                                        .copyWith(color: Colors.white),
                                  ),
                          )),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  loading() {
    return const CircularProgressIndicator(color: Colors.white);
  }

  TextFormField emailField(TextEditingController controller,
      TextInputType inputType, String title, IconData icon) {
    return TextFormField(
      controller: controller,
      cursorColor: CoreColor.primary,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: title,
        labelStyle: const TextStyle(color: Colors.black),

        hintText: 'Enter your $title',
        // Here is key idea

        prefixIcon: Icon(icon, color: CoreColor.primary),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: CoreColor.primary, width: 1),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: CoreColor.primaryExtraSoft,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: CoreColor.kHintTextColor,
            width: 1,
          ),
        ),
      ),
    );
  }
}
