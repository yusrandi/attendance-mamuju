import 'package:attendance/app/modules/auth/controllers/authentication_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';
import 'package:intl/date_symbol_data_local.dart';

final AuthenticationManager _authManager = Get.put(AuthenticationManager());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('id_ID', null);
  await GetStorage.init();

  // _authManager.login('111');

  runApp(
    GetMaterialApp(
      theme: ThemeData(
        fontFamily: "Nunito",
        // appBarTheme: const AppBarTheme(
        //   iconTheme: IconThemeData(color: Colors.white),
        //   foregroundColor: Colors.white,
        //   systemOverlayStyle: SystemUiOverlayStyle(
        //     //<-- SEE HERE
        //     // Status bar color
        //     // statusBarColor: Colors.deepPurple,
        //     statusBarIconBrightness: Brightness.dark,
        //     statusBarBrightness: Brightness.light,
        //   ),
        // ),
      ),
      debugShowCheckedModeBanner: false,
      title: "Attendance",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
