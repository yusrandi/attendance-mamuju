import 'dart:convert';

import 'package:attendance/app/data/models/offices_model.dart';
import 'package:attendance/app/data/models/presensi_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../config/api.dart';

class PresensiService extends GetConnect {
  Future<PresensiModel> fetchPresensiThisMonthByUserNip(String nip) async {
    Uri url = Uri.parse('${Api().presensiUrl}/$nip');

    var res = await http.get(url);
    print(res.body);

    return PresensiModel.fromJson(json.decode(res.body));
  }
}
