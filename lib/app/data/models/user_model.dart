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
    this.device,
    this.preRoleId,
    this.preOfficeId,
    this.office,
  });

  int? id;
  String? nip;
  String? name;
  String? username;
  String? phone;
  String? isActive;
  String? status;
  String? device;
  String? preRoleId;
  String? preOfficeId;
  OfficeModel? office;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        nip: json["nip"],
        name: json["name"],
        username: json["username"],
        phone: json["phone"],
        isActive: json["is_active"],
        status: json["status"],
        device: json["device"],
        preRoleId: json["pre_role_id"].toString(),
        preOfficeId: json["pre_office_id"].toString(),
        office: OfficeModel.fromJson(json["office"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nip": nip,
        "name": name,
        "username": username,
        "phone": phone,
        "is_active": isActive,
        "status": status,
        "device": device,
        "pre_role_id": preRoleId,
        "pre_office_id": preOfficeId,
        "office": office!.toJson(),
      };
}
