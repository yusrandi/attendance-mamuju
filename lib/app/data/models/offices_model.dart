// To parse this JSON data, do
//
//     final officeModel = officeModelFromJson(jsonString);

import 'dart:convert';

OfficeModel officeModelFromJson(String str) =>
    OfficeModel.fromJson(json.decode(str));

String officeModelToJson(OfficeModel data) => json.encode(data.toJson());

class OfficeModel {
  OfficeModel({
    this.id,
    this.kodeInstansi,
    this.namaInstansi,
    this.location,
    this.radius,
    this.status,
  });

  int? id;
  String? kodeInstansi;
  String? namaInstansi;
  String? location;
  String? radius;
  String? status;

  factory OfficeModel.fromJson(Map<String, dynamic> json) => OfficeModel(
      id: json["id"],
      kodeInstansi: json["kode_instansi"],
      namaInstansi: json["nama_instansi"],
      location: json["location"],
      radius: json["radius"],
      status: json["status"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "kode_instansi": kodeInstansi,
        "nama_instansi": namaInstansi,
        "location": location,
        "radius": radius,
        "status": status,
      };
}
