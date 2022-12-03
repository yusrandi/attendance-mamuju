import 'package:attendance/app/cores/core_colors.dart';
import 'package:attendance/app/cores/core_images.dart';
import 'package:attendance/app/routes/app_pages.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../cores/core_constants.dart';
import '../../../cores/core_styles.dart';
import '../../../cores/helper/keyboard.dart';
import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  AuthView({Key? key}) : super(key: key);

  final AuthController authController = Get.put(AuthController());

  final _formKey = GlobalKey<FormState>();

  final _userEmail = TextEditingController();
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
    return Scaffold(
      backgroundColor: CoreColor.primary,
      body: Column(
        children: [
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(16),
            child: Center(child: Lottie.asset(CoreImages.attendanceLottie)),
          )),
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome Back",
                  style: CoreStyles.uTitle,
                ),
                const Text(
                  "Sign in with your Phone and password  \nto continue",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: (26)),
                emailField(_userEmail, validateEmail, TextInputType.phone,
                    'Phone', Icons.alternate_email_rounded),
                const SizedBox(height: (16)),
                passwordField(),
                const SizedBox(height: (26)),
                GestureDetector(
                  onTap: () async {
                    Get.offAndToNamed(Routes.BASE);
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
                              "Login",
                              style: CoreStyles.uSubTitle
                                  .copyWith(color: Colors.white),
                            ),
                    )),
                  ),
                ),
                SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                      text: 'belum punya akun ?',
                      style: CoreStyles.uContent,
                      children: <TextSpan>[
                        TextSpan(
                            text: ' Daftar sekarang',
                            style: CoreStyles.uSubTitle,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // navigate to desired screen
                                authController.count.value = 1;
                              })
                      ]),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  loading() {
    return const CircularProgressIndicator(color: Colors.white);
  }

  TextFormField emailField(
      TextEditingController controller,
      String? Function(String?) validator,
      TextInputType inputType,
      String title,
      IconData icon) {
    return TextFormField(
      controller: controller,
      validator: validator,
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
}
