import 'dart:convert';

import 'package:attendance/app/data/config/api.dart';
import 'package:attendance/app/data/models/offices_model.dart';
import 'package:attendance/app/data/models/presensi_model.dart';
import 'package:attendance/app/data/models/user_model.dart';
import 'package:attendance/app/data/services/office_services.dart';
import 'package:attendance/app/data/services/presensi_services.dart';
import 'package:attendance/app/data/services/user_services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  OfficeModel response = await OfficeService().fetchOfficesByUserId('555');

  print(response.location);
}
