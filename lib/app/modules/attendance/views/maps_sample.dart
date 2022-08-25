import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:attendance/app/cores/core_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();

  Map<CircleId, Circle> circles = <CircleId, Circle>{};
  int _circleIdCounter = 1;
  CircleId? selectedCircle;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId? selectedMarker;
  int _markerIdCounter = 1;
  LatLng? markerPosition;

  static const LatLng center = LatLng(-5.078997, 119.528346);

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-5.078997, 119.528346),
    zoom: 18.0,
    bearing: 30,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(-5.078997, 119.528346),
      tilt: 59.440717697143555,
      zoom: 16);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String circleIdVal = 'circle_id_$_circleIdCounter';
    _circleIdCounter++;
    final CircleId circleId = CircleId(circleIdVal);

    final Circle circle = Circle(
      circleId: circleId,
      consumeTapEvents: true,
      strokeColor: CoreColor.primary,
      fillColor: Colors.transparent,
      strokeWidth: 3,
      center: _createCenter(),
      radius: 50,
      onTap: () {
        _onCircleTapped(circleId);
      },
    );

    setState(() {
      circles[circleId] = circle;
    });

    _addMarker();

    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        circles: Set<Circle>.of(circles.values),
        markers: Set<Marker>.of(markers.values),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  void _addMarker() async {
    final Uint8List customMarker = await getBytesFromAsset(
        path: "assets/images/pin.png", //paste the custom image path
        width: 150 // size of custom image as marker
        );

    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;

    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        center.latitude,
        center.longitude,
      ),
      icon: BitmapDescriptor.fromBytes(customMarker),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  LatLng _createCenter() {
    final double offset = _circleIdCounter.ceilToDouble();
    return _createLatLng(-5.078997, 119.528346);
  }

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }

  void _onCircleTapped(CircleId circleId) {
    setState(() {
      selectedCircle = circleId;
    });
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
