import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await initializeDateFormatting('id_ID', null);

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
