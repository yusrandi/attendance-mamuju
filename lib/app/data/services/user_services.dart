import 'dart:convert';

import 'package:attendance/app/data/models/offices_model.dart';
import 'package:attendance/app/data/models/presensi_model.dart';
import 'package:attendance/app/data/models/user_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../config/api.dart';

class UserService extends GetConnect {
  Future<UserModel> fetchUserByUserNip(String nip) async {
    Uri url = Uri.parse('${Api().userByNipUrl}/$nip');

    var res = await http.get(url);

    print(res.body);

    return UserModel.fromJson(json.decode(res.body)['user']);
  }
}
