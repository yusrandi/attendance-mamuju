import 'dart:async';
import 'dart:io';

import 'package:attendance/app/cores/core_colors.dart';
import 'package:attendance/app/cores/core_styles.dart';
import 'package:attendance/app/data/models/offices_model.dart';
import 'package:attendance/app/routes/app_pages.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../../../cores/core_images.dart';
import '../controllers/attendance_controller.dart';

class AttendanceView extends GetView<AttendanceController> {
  AttendanceView({Key? key}) : super(key: key);

  final AttendanceController attendanceController = Get.find();
  // final Completer<GoogleMapController> _controller = Completer();

  LatLng? latPos;

  XFile? ximage;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    // CameraPosition initCameraPos = CameraPosition(
    //     target: latPos!, zoom: attendanceController.zoomPos.value, bearing: 30);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            )),
      ),
      body: body(size, context),
    );
  }

  Stack body(Size size, BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Obx(
            () => attendanceController.status == Status.running
                ? Center(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container(child: bodyLeafLeft()),
          ),
        ),
        Positioned(
          bottom: size.height * 0.45,
          right: 16,
          child: FloatingActionButton(
            backgroundColor: CoreColor.primary,
            onPressed: () async {
              await attendanceController.getGeoLocationPosition();
            },
            child: const Icon(Icons.location_searching_rounded),
          ),
        ),
        // Positioned(
        //   left: 8,
        //   top: 56,
        //   child: GestureDetector(
        //     onTap: () => Get.offAndToNamed(Routes.BASE),
        //     child: Icon(
        //       Icons.arrow_back_ios_new_rounded,
        //       size: 40,
        //     ),
        //   ),
        // ),
        customBody(size, context),
      ],
    );
  }

  bodyLeafLeft() {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(double.parse(attendanceController.latPos.value),
            attendanceController.lngPos.value),
        zoom: attendanceController.zoomPos.value,
      ),
      nonRotatedChildren: [
        AttributionWidget.defaultWidget(
          source: 'OpenStreetMap contributors',
          onSourceTapped: () {},
        ),
      ],
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'dev.fleaflet.flutter_map.example',
        ),
        MarkerLayer(markers: attendanceController.markers),
        CircleLayer(circles: attendanceController.circles),
      ],
    );
  }

  // Obx bodyGoogleMaps(CameraPosition initCameraPos) {
  //   return Obx(
  //     () => GoogleMap(
  //       mapType: MapType.normal,
  //       initialCameraPosition: initCameraPos,
  //       circles: Set<Circle>.of(attendanceController.circles.values),
  //       markers: Set<Marker>.of(attendanceController.markers.values),
  //       onMapCreated: (GoogleMapController controller) {
  //         _controller.complete(controller);
  //       },
  //     ),
  //   );
  // }

  customBody(Size size, BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.4,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
              controller: scrollController, child: detailBody(size, context)),
        );
      },
    );
  }

  detailBody(Size size, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: CoreStyles.uTitle.copyWith(fontSize: 18, color: Colors.black),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Text(
            attendanceController.address.value,
            style: CoreStyles.uContent
                .copyWith(fontSize: 14, color: CoreColor.kHintTextColor),
          ),
        ),
        const SizedBox(height: 16),

        GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute<bool>(
                builder: (BuildContext context) {
                  return cameraPage(context, size);
                },
              ));
            },
            child: Column(
              children: [
                Obx(
                  () => attendanceController.imagePath.value != ""
                      ? Container(
                          height: 200,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(File(
                                      attendanceController.imagePath.value)))))
                      : SvgPicture.asset(
                          "assets/icons/add-account.svg",
                          height: 150,
                        ),
                ),
                Text(
                  'please tap to take picture',
                  style: CoreStyles.uContent
                      .copyWith(fontSize: 14, color: CoreColor.kHintTextColor),
                ),
              ],
            )),
        const Divider(),

        const SizedBox(height: 16),
        // GestureDetector(
        //     onTap: () {
        //       Navigator.of(context).push(MaterialPageRoute<bool>(
        //         builder: (BuildContext context) {
        //           return Scaffold(
        //             appBar: AppBar(
        //               backgroundColor: CoreColor.primary,
        //               title: const Text("Pilih Status Absen"),
        //               elevation: 0,
        //             ),
        //             body: WillPopScope(
        //               onWillPop: () async {
        //                 Navigator.pop(context, false);
        //                 return false;
        //               },
        //               child: listKeterangan(),
        //             ),
        //           );
        //         },
        //       ));
        //     },
        //     child: keteranganField()),
        const SizedBox(height: 16),

        // listSubMenu(),
        // listSubMenu(),

        detailClockIn(),
        sliderBody(),
      ],
    );
  }

  Row detailClockIn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Clock In',
              style:
                  CoreStyles.uTitle.copyWith(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Text(
                attendanceController.clockIn.value,
                style: CoreStyles.uContent
                    .copyWith(fontSize: 14, color: Colors.red),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Clock Out',
              style:
                  CoreStyles.uTitle.copyWith(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Text(
                attendanceController.clockOut.value,
                style: CoreStyles.uContent
                    .copyWith(fontSize: 14, color: Colors.red),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Container listKeterangan() {
    var list = ["Jam Pagi", "Jam Siang", "Jam Sore"];
    return Container(
      child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(),
              padding: EdgeInsets.only(left: 16, right: 16, top: 16),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context, false);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      list[index],
                      style: TextStyle(fontSize: 18),
                    ),
                    Divider(),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Container keteranganField() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: const [
          Icon(
            Icons.list,
            color: Colors.grey,
            size: 16,
          ),
          SizedBox(width: 16),
          Expanded(
              child: Text(
            'sialhkan pilih waktu absen',
            style: TextStyle(fontSize: 16),
          )),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
            size: 16,
          ),
        ],
      ),
    );
  }

  Scaffold cameraPage(BuildContext context, Size size) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            )),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, false);
          return false;
        },
        child: FutureBuilder(
          future: attendanceController.initCamera(),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.done
                  ? Stack(
                      children: [
                        SizedBox(
                            width: size.width,
                            height: size.height,
                            child: CameraPreview(
                                attendanceController.cameraController)),
                        SizedBox(
                            width: size.width,
                            height: size.height,
                            child: Image.asset(
                              CoreImages.layerImages,
                              fit: BoxFit.fill,
                            )),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 32),
                              child: FloatingActionButton(
                                onPressed: () async {
                                  if (!attendanceController
                                      .cameraController.value.isTakingPicture) {
                                    attendanceController.getImage();

                                    // ignore: use_build_context_synchronously
                                    Navigator.pop(context, false);
                                  }
                                },
                                backgroundColor: CoreColor.primary,
                              ),
                            )),
                      ],
                    )
                  : const SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  sliderBody() {
    return Obx(
      () => attendanceController.status == Status.running
          ? Center(
              child: CircularProgressIndicator(
                color: CoreColor.primary,
              ),
            )
          : Container(
              padding: const EdgeInsets.only(bottom: 16),
              child: Builder(
                builder: (context) {
                  final GlobalKey<SlideActionState> _key = GlobalKey();
                  return SlideAction(
                    key: _key,
                    onSubmit: () {
                      Future.delayed(
                        const Duration(seconds: 1),
                        () async =>
                            await attendanceController.attendanceStore(),
                      );
                    },
                    alignment: Alignment.centerRight,
                    child: const Text(
                      ' Swipe Right to CLOCK IN',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    sliderButtonIcon: Icon(Icons.arrow_forward_ios_rounded,
                        color: CoreColor.primary),
                    innerColor: Colors.white,
                    outerColor: CoreColor.primary,
                    borderRadius: 16,
                  );
                },
              ),
            ),
    );
  }

  Container listSubMenu() {
    List<String> listMenu = [
      'Absen Pagi',
      'Absen Siang',
      'Absen Sore',
      'Sift Siang',
      'Sift Malam',
    ];
    return Container(
      height: 40,
      margin: const EdgeInsets.only(top: 16),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Obx(
            () => GestureDetector(
              onTap: () => attendanceController.count.value = index,
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 32),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(),
                    color: attendanceController.count.value == index
                        ? CoreColor.primary
                        : Colors.white),
                child: Center(
                  child: Text(
                    listMenu[index],
                    style: CoreStyles.uContent.copyWith(
                        color: attendanceController.count.value == index
                            ? Colors.white
                            : CoreColor.kTextColor),
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: listMenu.length,
      ),
    );
  }
}
