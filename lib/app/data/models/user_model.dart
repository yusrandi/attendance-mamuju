// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

import 'package:attendance/app/data/models/offices_model.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    this.id,
    this.nip,
    this.name,
    this.username,
    this.phone,
    this.isActive,
    this.status,
    this.canAccess,
    this.allAccess,
    this.device,
    this.preRoleId,
    this.preOfficeId,
    this.preAbsenCategoryId,
    this.office,
    this.absenCategory,
  });

  int? id;
  String? nip;
  String? name;
  String? username;
  String? phone;
  String? isActive;
  String? status;
  String? canAccess;
  String? allAccess;
  String? device;
  int? preRoleId;
  int? preOfficeId;
  int? preAbsenCategoryId;
  OfficeModel? office;
  AbsenCategory? absenCategory;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        nip: json["nip"],
        name: json["name"],
        username: json["username"],
        phone: json["phone"],
        isActive: json["is_active"],
        status: json["status"],
        canAccess: json["can_access"],
        allAccess: json["all_access"],
        device: json["device"],
        preRoleId: json["pre_role_id"],
        preOfficeId: json["pre_office_id"],
        preAbsenCategoryId: json["pre_absen_category_id"],
        office: OfficeModel.fromJson(json["office"]),
        absenCategory: AbsenCategory.fromJson(json["absen_category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nip": nip,
        "name": name,
        "username": username,
        "phone": phone,
        "is_active": isActive,
        "status": status,
        "can_access": canAccess,
        "all_access": allAccess,
        "device": device,
        "pre_role_id": preRoleId,
        "pre_office_id": preOfficeId,
        "pre_absen_category_id": preAbsenCategoryId,
        "office": office!.toJson(),
        "absen_category": absenCategory!.toJson(),
      };
}

class AbsenCategory {
  AbsenCategory({
    this.id,
    this.description,
    this.absens,
  });

  int? id;
  String? description;
  List<Absen>? absens;

  factory AbsenCategory.fromJson(Map<String, dynamic> json) => AbsenCategory(
        id: json["id"],
        description: json["description"],
        absens: List<Absen>.from(json["absens"].map((x) => Absen.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "absens": List<dynamic>.from(absens!.map((x) => x.toJson())),
      };
}

class Absen {
  Absen({
    this.id,
    this.begin,
    this.end,
    this.total,
    this.clockIn,
    this.clockOut,
    this.desc,
    this.days,
    this.isActive,
    this.preAbsenCategoryId,
  });

  int? id;
  String? begin;
  String? end;
  String? total;
  String? clockIn;
  String? clockOut;
  String? desc;
  String? days;
  String? isActive;
  int? preAbsenCategoryId;

  factory Absen.fromJson(Map<String, dynamic> json) => Absen(
        id: json["id"],
        begin: json["begin"],
        end: json["end"],
        total: json["total"],
        clockIn: json["clock_in"],
        clockOut: json["clock_out"],
        desc: json["desc"],
        days: json["days"],
        isActive: json["is_active"],
        preAbsenCategoryId: json["pre_absen_category_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "begin": begin,
        "end": end,
        "total": total,
        "clock_in": clockIn,
        "clock_out": clockOut,
        "desc": desc,
        "days": days,
        "is_active": isActive,
        "pre_absen_category_id": preAbsenCategoryId,
      };
}
