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
    this.name,
    this.phone,
    this.address,
    this.location,
    this.radius,
  });

  int? id;
  String? name;
  String? phone;
  String? address;
  String? location;
  String? radius;

  factory OfficeModel.fromJson(Map<String, dynamic> json) => OfficeModel(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        address: json["address"],
        location: json["location"],
        radius: json["radius"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "address": address,
        "location": location,
        "radius": radius,
      };
}
