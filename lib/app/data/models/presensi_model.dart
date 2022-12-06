// To parse this JSON data, do
//
//     final presensiModel = presensiModelFromJson(jsonString);

import 'dart:convert';

PresensiModel presensiModelFromJson(String str) =>
    PresensiModel.fromJson(json.decode(str));

String presensiModelToJson(PresensiModel data) => json.encode(data.toJson());

class PresensiModel {
  PresensiModel({
    this.responsecode,
    this.responsemsg,
    this.month,
    this.presensi,
    this.monthnumber,
  });

  String? responsecode;
  String? responsemsg;
  String? month;
  String? monthnumber;
  List<Presensi>? presensi;

  factory PresensiModel.fromJson(Map<String, dynamic> json) => PresensiModel(
        responsecode: json["responsecode"],
        responsemsg: json["responsemsg"],
        month: json["month"],
        monthnumber: json["monthnumber"],
        presensi: List<Presensi>.from(
            json["presensi"].map((x) => Presensi.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "responsecode": responsecode,
        "responsemsg": responsemsg,
        "month": month,
        "monthnumber": monthnumber,
        "presensi": List<dynamic>.from(presensi!.map((x) => x.toJson())),
      };
}

class Presensi {
  Presensi({
    this.hari,
    this.tanggal,
    this.masuk,
    this.pulang,
    this.leaves,
  });

  String? hari;
  String? tanggal;
  String? masuk;
  String? pulang;
  String? leaves;

  factory Presensi.fromJson(Map<String, dynamic> json) => Presensi(
        hari: json["hari"],
        tanggal: json["tanggal"],
        masuk: json["masuk"],
        pulang: json["pulang"],
        leaves: json["leaves"],
      );

  Map<String, dynamic> toJson() => {
        "hari": hari,
        "tanggal": tanggal,
        "masuk": masuk,
        "pulang": pulang,
        "leaves": leaves,
      };
}
