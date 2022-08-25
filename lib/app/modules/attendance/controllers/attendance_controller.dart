import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../cores/core_colors.dart';

class AttendanceController extends GetxController {
  final count = 0.obs;
  double latPos = -5.078997.obs;
  RxDouble lngPos = 119.528346.obs;
  RxDouble zoomPos = 19.0.obs;

  Map<CircleId, Circle> circles = <CircleId, Circle>{}.obs;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;

  @override
  void onInit() {
    super.onInit();

    addCircle();
    addMarker();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  addCircle() {
    final CircleId circleId = CircleId("circleIdVal");

    final Circle circle = Circle(
      circleId: circleId,
      consumeTapEvents: true,
      strokeColor: CoreColor.primary,
      fillColor: Colors.transparent,
      strokeWidth: 3,
      center: LatLng(latPos, lngPos.value),
      radius: 50,
    );

    circles[circleId] = circle;
  }

  addMarker() async {
    final Uint8List customMarker = await getBytesFromAsset(
        path: "assets/images/pin.png", //paste the custom image path
        width: 150 // size of custom image as marker
        );

    final MarkerId markerId = MarkerId("markerIdVal");

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        latPos,
        lngPos.value,
      ),
      icon: BitmapDescriptor.fromBytes(customMarker),
      infoWindow: InfoWindow(title: "Office", snippet: 'Jl. Our Office'),
    );

    markers[markerId] = marker;
  }

  Future<Uint8List> getBytesFromAsset(
      {required String path, required int width}) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
