import 'dart:convert';
import 'dart:io';

import 'package:attendance/app/data/models/offices_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../cores/core_colors.dart';
import '../../routes/app_pages.dart';
import '../config/api.dart';

class AttendanceService extends GetConnect {
  Future<String> attendanceStore(
      File? photo, String nip, String location, String absenId) async {
    var request = http.MultipartRequest(
        "POST", Uri.parse(Api.instance.getAttendancesUrl));

    request.fields['nip'] = nip;
    request.fields['location'] = location;
    request.fields['absen_id'] = absenId;

    if (photo != null) {
      final resFile = await http.MultipartFile.fromPath('photo', photo.path,
          contentType: MediaType('application', 'x-tar'));
      request.files.add(resFile);
    } else {
      request.fields['photo'] = "";
    }

    final data = await request.send();
    final response = await http.Response.fromStream(data);
    print("response ${response.body}");

    if (response.statusCode == 201) {
      var data = json.decode(response.body);

      if (data['responsecode'] == '1') {
        print("Data ${data['responsemsg']}");

        Get.snackbar("absen bos", "Terima kasih, telah mengisi kehadiran",
            backgroundColor: CoreColor.whiteSoft,
            duration: const Duration(seconds: 2));
        Get.offAllNamed(Routes.BASE);
      } else {
        print("Data ${data['responsemsg']}");

        Get.snackbar("SIKEREN", data['responsemsg'],
            backgroundColor: CoreColor.whiteSoft,
            duration: const Duration(seconds: 2));
      }

      return 'berhasil';
    } else {
      throw Exception();
      // return 'gagal';
    }
  }
}
