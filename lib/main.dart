import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      theme: ThemeData(
        fontFamily: "Nunito",
        appBarTheme: const AppBarTheme(
          brightness: Brightness.dark,
          iconTheme: IconThemeData(color: Colors.black),
          foregroundColor: Colors.black,
          systemOverlayStyle: SystemUiOverlayStyle(
            //<-- SEE HERE
            // Status bar color
            statusBarColor: Colors.green,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: "Attendance",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
