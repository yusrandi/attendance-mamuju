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
    this.absens,
  });

  int? id;
  String? kodeInstansi;
  String? namaInstansi;
  String? location;
  String? radius;
  String? status;
  List<Absen>? absens;

  factory OfficeModel.fromJson(Map<String, dynamic> json) => OfficeModel(
        id: json["id"],
        kodeInstansi: json["kode_instansi"],
        namaInstansi: json["nama_instansi"],
        location: json["location"],
        radius: json["radius"],
        status: json["status"],
        absens: List<Absen>.from(json["absens"].map((x) => Absen.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kode_instansi": kodeInstansi,
        "nama_instansi": namaInstansi,
        "location": location,
        "radius": radius,
        "status": status,
        "absens": List<dynamic>.from(absens!.map((x) => x.toJson())),
      };
}

class Absen {
  Absen({
    this.id,
    this.begin,
    this.end,
    this.clockIn,
    this.clockOut,
    this.desc,
    this.days,
    this.isActive,
  });

  int? id;
  String? begin;
  String? end;
  String? clockIn;
  String? clockOut;
  String? desc;
  String? days;
  String? isActive;

  factory Absen.fromJson(Map<String, dynamic> json) => Absen(
        id: json["id"],
        begin: json["begin"],
        end: json["end"],
        clockIn: json["clock_in"],
        clockOut: json["clock_out"],
        desc: json["desc"],
        days: json["days"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "begin": begin,
        "end": end,
        "clock_in": clockIn,
        "clock_out": clockOut,
        "desc": desc,
        "days": days,
        "is_active": isActive,
      };
}
