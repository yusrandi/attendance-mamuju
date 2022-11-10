import 'package:attendance/app/cores/core_images.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/selfi_controller.dart';

class SelfiView extends GetView<SelfiController> {
  SelfiView({Key? key}) : super(key: key);
  final SelfiController selfiController = Get.put(SelfiController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Take your selfi'),
      ),
      body: FutureBuilder(
        future: selfiController.initCamera(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.done
            ? Stack(
                children: [
                  SizedBox(
                      width: size.width,
                      height: size.height,
                      child: CameraPreview(selfiController.cameraController)),
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
                          onPressed: () {},
                          backgroundColor: Colors.deepPurple,
                        ),
                      )),
                ],
              )
            : const SizedBox(
                height: 50, width: 50, child: CircularProgressIndicator()),
      ),
    );
  }
}
