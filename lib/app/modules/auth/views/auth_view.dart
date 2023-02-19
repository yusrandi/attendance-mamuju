import 'package:attendance/app/cores/core_colors.dart';
import 'package:attendance/app/cores/core_images.dart';
import 'package:attendance/app/routes/app_pages.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../cores/core_constants.dart';
import '../../../cores/core_strings.dart';
import '../../../cores/core_styles.dart';
import '../../../cores/helper/keyboard.dart';
import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  AuthView({Key? key}) : super(key: key);

  final AuthController authController = Get.put(AuthController());

  final _formKey = GlobalKey<FormState>();

  final _userEmail = TextEditingController();
  final _userOtp = TextEditingController();
  final _userPass = TextEditingController();

  String? validatePass(value) {
    if (value.isEmpty) {
      return kPassNullError;
    } else if (value.length < 8) {
      return kShortPassError;
    } else {
      return null;
    }
  }

  String? validateEmail(value) {
    if (value.isEmpty) {
      return kPhoneNumberNullError;
    } else {
      return null;
    }
  }

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
          children: [
            Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      CoreStrings.appName,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: CoreColor.primary),
                    ),
                    Text(CoreStrings.welcomeTitle,
                        style: Theme.of(context).textTheme.titleSmall),
                  ],
                )),
            Expanded(
                flex: 3,
                child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: authViewPage(context, size))),
          ],
        ),
      ),
    );
  }

  authViewPage(BuildContext context, Size size) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: double.infinity,
              child: Lottie.asset(CoreImages.attendanceLottie,
                  height: size.width * 0.3)),
          const SizedBox(height: (16)),
          Text(
            "Welcome Back",
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: (16)),
          emailField(_userEmail, TextInputType.text, 'Username',
              Icons.perm_identity_rounded),
          const SizedBox(height: (8)),

          passwordField(),
          const SizedBox(height: (26)),
          GestureDetector(
            onTap: () async {
              // Get.toNamed(Routes.OTP);
              // authController.verifyPhoneNumber(_userEmail.text);
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                var email = _userEmail.text.trim();
                var password = _userPass.text.trim();

                print(email);
                await authController.loginUser(email, password);
                KeyboardUtil.hideKeyboard(context);
              }
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  color: CoreColor.primary,
                  borderRadius: BorderRadius.circular(20)),
              child: Center(
                  child: Obx(
                () => authController.status.value == Status.running
                    ? loading()
                    : Text(
                        "login",
                        style:
                            CoreStyles.uSubTitle.copyWith(color: Colors.white),
                      ),
              )),
            ),
          ),
          const SizedBox(height: 16),
          // RichText(

          //   text: TextSpan(
          //       text: 'belum punya akun ?',
          //       style: CoreStyles.uContent,
          //       children: <TextSpan>[
          //         TextSpan(
          //             text: ' Daftar sekarang',
          //             style: CoreStyles.uSubTitle,
          //             recognizer: TapGestureRecognizer()
          //               ..onTap = () {
          //                 // navigate to desired screen
          //                 authController.count.value = 1;
          //               })
          //       ]),
          // ),
        ],
      ),
    );
  }

  loading() {
    return const CircularProgressIndicator(color: Colors.white);
  }

  TextFormField emailField(TextEditingController controller,
      TextInputType inputType, String title, IconData icon) {
    return TextFormField(
      validator: validateEmail,
      controller: controller,
      cursorColor: CoreColor.primary,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: title,
        labelStyle: const TextStyle(color: Colors.black),

        hintText: 'Your $title',
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

  passwordField() {
    return Obx(() => TextFormField(
          controller: _userPass,
          validator: validatePass,
          cursorColor: CoreColor.primary,
          keyboardType: TextInputType.text,
          obscureText: !authController
              .passwordVisible.value, //This will obscure text dynamically
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: const TextStyle(color: Colors.black),

            hintText: 'Enter your password',
            // Here is key idea
            suffixIcon: IconButton(
              icon: Icon(
                // Based on passwordVisible state choose the icon
                authController.passwordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: CoreColor.primary,
              ),
              onPressed: () {
                // Update the state i.e. toogle the state of passwordVisible variable

                authController.passwordVisible.value =
                    !authController.passwordVisible.value;
              },
            ),

            prefixIcon:
                Icon(Icons.lock_outline_rounded, color: CoreColor.primary),
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
        ));
  }

  Column otpView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: double.infinity,
            child: Lottie.asset(CoreImages.attendanceLottie, height: 200)),
        Text(
          "OTP Code",
          style: CoreStyles.uTitle,
        ),
        const SizedBox(height: (16)),
        emailField(_userOtp, TextInputType.phone, 'OTP Code', Icons.code),
        const SizedBox(height: (8)),
        const Text(
          "button next will be appear if otp code is valid",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: (16)),
        GestureDetector(
          onTap: () async {
            // await authController.verifCode(_userOtp.text);
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
              () => authController.status.value == Status.running
                  ? loading()
                  : Text(
                      "Continue",
                      style: CoreStyles.uSubTitle.copyWith(color: Colors.white),
                    ),
            )),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Column landingView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
            width: double.infinity,
            child: Lottie.asset(CoreImages.attendanceLottie, height: 200)),
        Text(
          "Almost done",
          style: CoreStyles.uTitle,
        ),
        const SizedBox(height: (16)),
        const Text(
          "we'l get your data, please wait this may take a minute",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: (16)),
        const CircularProgressIndicator(),
        SizedBox(height: 16),
      ],
    );
  }
}
