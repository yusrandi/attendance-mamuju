import 'dart:convert';

import 'package:attendance/app/data/models/offices_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../config/api.dart';

class OfficeService extends GetConnect {
  Future<List<OfficeModel>> fetchOffices() async {
    Uri url = Uri.parse(Api().getOfficesUrl);

    var res = await http.get(url);
    List data = (json.decode(res.body) as Map<String, dynamic>)["data"];

    // print(data);

    if (data.isEmpty) {
      return [];
    } else {
      return data.map((e) => OfficeModel.fromJson(e)).toList();
    }
  }

  Future<OfficeModel> fetchOfficesByUserId(String userId) async {
    Uri url = Uri.parse('${Api().getOfficesUrl}/$userId');

    var res = await http.get(url);

    // print(res.body);

    return OfficeModel.fromJson(json.decode(res.body)['data']);
  }
}
