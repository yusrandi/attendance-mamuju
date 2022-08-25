import 'dart:async';

import 'package:attendance/app/cores/core_colors.dart';
import 'package:attendance/app/cores/core_styles.dart';
import 'package:attendance/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../controllers/attendance_controller.dart';

class AttendanceView extends GetView<AttendanceController> {
  AttendanceView({Key? key}) : super(key: key);

  final AttendanceController attendanceController = Get.find();
  final Completer<GoogleMapController> _controller = Completer();

  LatLng? latPos;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    latPos =
        LatLng(attendanceController.latPos, attendanceController.lngPos.value);

    CameraPosition initCameraPos = CameraPosition(
        target: latPos!, zoom: attendanceController.zoomPos.value, bearing: 30);

    return Scaffold(
      body: body(size, initCameraPos),
    );
  }

  Stack body(Size size, CameraPosition initCameraPos) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          bottom: size.height * 0.2,
          left: 0,
          right: 0,
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: initCameraPos,
            circles: Set<Circle>.of(attendanceController.circles.values),
            markers: Set<Marker>.of(attendanceController.markers.values),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
        Positioned(
          left: 8,
          top: 56,
          child: GestureDetector(
            onTap: () => Get.offAndToNamed(Routes.BASE),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 40,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.all(16),
            height: size.height * 0.35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Location',
                        style: CoreStyles.uTitle
                            .copyWith(fontSize: 18, color: Colors.black),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Masjid Babussalam BPS, Sudiang, Biringkanaya, Makassar City, South Sulawesi 90242',
                        style: CoreStyles.uContent.copyWith(
                            fontSize: 14, color: CoreColor.kHintTextColor),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Clock In',
                            style: CoreStyles.uTitle
                                .copyWith(fontSize: 18, color: Colors.black),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '08:00',
                            style: CoreStyles.uContent.copyWith(
                                fontSize: 14, color: CoreColor.primary),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Clock Out',
                            style: CoreStyles.uTitle
                                .copyWith(fontSize: 18, color: Colors.black),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '16:00',
                            style: CoreStyles.uContent
                                .copyWith(fontSize: 14, color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Builder(
                    builder: (context) {
                      final GlobalKey<SlideActionState> _key = GlobalKey();
                      return SlideAction(
                        key: _key,
                        onSubmit: () {
                          Future.delayed(
                            Duration(seconds: 1),
                            () => _key.currentState!.reset(),
                          );
                        },
                        alignment: Alignment.centerRight,
                        child: const Text(
                          ' Swipe Right to CLOCK IN',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        sliderButtonIcon: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.deepPurple),
                        innerColor: Colors.white,
                        outerColor: Colors.deepPurple,
                        borderRadius: 16,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  slider() {
    return Center(
      child: ListView(
        children: <Widget>[
          Builder(
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SlideAction(),
              );
            },
          ),
          Builder(
            builder: (context) {
              final GlobalKey<SlideActionState> _key = GlobalKey();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SlideAction(
                  key: _key,
                  onSubmit: () {
                    Future.delayed(
                      Duration(seconds: 1),
                      () => _key.currentState!.reset(),
                    );
                  },
                ),
              );
            },
          ),
          Builder(
            builder: (context) {
              final GlobalKey<SlideActionState> _key = GlobalKey();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SlideAction(
                  key: _key,
                  onSubmit: () {
                    Future.delayed(
                      Duration(seconds: 1),
                      () => _key.currentState!.reset(),
                    );
                  },
                  innerColor: Colors.black,
                  outerColor: Colors.white,
                ),
              );
            },
          ),
          Builder(
            builder: (context) {
              final GlobalKey<SlideActionState> _key = GlobalKey();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SlideAction(
                  key: _key,
                  onSubmit: () {
                    Future.delayed(
                      Duration(seconds: 1),
                      () => _key.currentState!.reset(),
                    );
                  },
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Unlock',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  sliderButtonIcon: Icon(Icons.lock),
                ),
              );
            },
          ),
          Builder(
            builder: (context) {
              final GlobalKey<SlideActionState> _key = GlobalKey();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SlideAction(
                  key: _key,
                  onSubmit: () {
                    Future.delayed(
                      Duration(seconds: 1),
                      () => _key.currentState!.reset(),
                    );
                  },
                  height: 100,
                ),
              );
            },
          ),
          Builder(
            builder: (context) {
              final GlobalKey<SlideActionState> _key = GlobalKey();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SlideAction(
                  key: _key,
                  onSubmit: () {
                    Future.delayed(
                      Duration(seconds: 1),
                      () => _key.currentState!.reset(),
                    );
                  },
                  sliderButtonIconSize: 48,
                  sliderButtonYOffset: -20,
                ),
              );
            },
          ),
          Builder(
            builder: (context) {
              final GlobalKey<SlideActionState> _key = GlobalKey();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SlideAction(
                  key: _key,
                  onSubmit: () {
                    Future.delayed(
                      Duration(seconds: 1),
                      () => _key.currentState!.reset(),
                    );
                  },
                  elevation: 24,
                ),
              );
            },
          ),
          Builder(
            builder: (context) {
              final GlobalKey<SlideActionState> _key = GlobalKey();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SlideAction(
                  key: _key,
                  onSubmit: () {
                    Future.delayed(
                      Duration(seconds: 1),
                      () => _key.currentState!.reset(),
                    );
                  },
                  borderRadius: 16,
                  animationDuration: Duration(seconds: 1),
                ),
              );
            },
          ),
          Builder(
            builder: (context) {
              final GlobalKey<SlideActionState> _key = GlobalKey();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SlideAction(
                  key: _key,
                  onSubmit: () {
                    Future.delayed(
                      Duration(seconds: 1),
                      () => _key.currentState!.reset(),
                    );
                  },
                  reversed: true,
                ),
              );
            },
          ),
          Builder(
            builder: (context) {
              final GlobalKey<SlideActionState> _key = GlobalKey();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SlideAction(
                  key: _key,
                  onSubmit: () {
                    Future.delayed(
                      Duration(seconds: 1),
                      () => _key.currentState!.reset(),
                    );
                  },
                  submittedIcon: Icon(
                    Icons.done_all,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          Builder(
            builder: (context) {
              final GlobalKey<SlideActionState> _key = GlobalKey();
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SlideAction(
                  key: _key,
                  onSubmit: () {
                    Future.delayed(
                      Duration(seconds: 1),
                      () => _key.currentState!.reset(),
                    );
                  },
                ),
              );
            },
          ),
          Builder(
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SlideAction(
                  sliderRotate: false,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
