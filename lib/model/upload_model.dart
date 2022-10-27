// To parse this JSON data, do
//
//     final uploadModel = uploadModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

UploadModel uploadModelFromJson(String str) =>
    UploadModel.fromJson(json.decode(str));

String uploadModelToJson(UploadModel data) => json.encode(data.toJson());

class UploadModel {
  UploadModel({
    required this.status,
    required this.messages,
    required this.data,
  });

  String status;
  List<String> messages;
  Data data;

  factory UploadModel.fromJson(Map<String, dynamic> json) => UploadModel(
        status: json["status"],
        messages: List<String>.from(json["messages"].map((x) => x)),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "messages": List<dynamic>.from(messages.map((x) => x)),
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.id,
    required this.code,
    required this.title,
    required this.transDate,
    required this.name,
    required this.birthDate,
    required this.formType,
    required this.municipality,
    required this.subDistrict,
    required this.village,
    required this.subVillage,
    required this.interviewerName,
    required this.transTime,
    required this.deviceId,
  });

  int id;
  String code;
  String title;
  DateTime transDate;
  String name;
  DateTime birthDate;
  dynamic formType;
  Municipality municipality;
  Municipality subDistrict;
  Municipality village;
  Municipality subVillage;
  String interviewerName;
  String transTime;
  String deviceId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        code: json["code"],
        title: json["title"],
        transDate: DateTime.parse(json["transDate"]),
        name: json["name"],
        birthDate: DateTime.parse(json["birthDate"]),
        formType: json["formType"],
        municipality: Municipality.fromJson(json["municipality"]),
        subDistrict: Municipality.fromJson(json["subDistrict"]),
        village: Municipality.fromJson(json["village"]),
        subVillage: Municipality.fromJson(json["subVillage"]),
        interviewerName: json["interviewerName"],
        transTime: json["transTime"],
        deviceId: json["deviceId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "title": title,
        "transDate": transDate.toIso8601String(),
        "name": name,
        "birthDate": birthDate.toIso8601String(),
        "formType": formType,
        "municipality": municipality.toJson(),
        "subDistrict": subDistrict.toJson(),
        "village": village.toJson(),
        "subVillage": subVillage.toJson(),
        "interviewerName": interviewerName,
        "transTime": transTime,
        "deviceId": deviceId,
      };
}

class Municipality {
  Municipality({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.municipality,
    required this.village,
    required this.subDistrict,
  });

  int id;
  String code;
  String name;
  String description;
  Municipality? municipality;
  Municipality? village;
  Municipality? subDistrict;

  factory Municipality.fromJson(Map<String, dynamic> json) => Municipality(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        description: json["description"],
        municipality: json["municipality"] == null
            ? null
            : Municipality.fromJson(json["municipality"]),
        village: json["village"] == null
            ? null
            : Municipality.fromJson(json["village"]),
        subDistrict: json["subDistrict"] == null
            ? null
            : Municipality.fromJson(json["subDistrict"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "description": description,
        "municipality": municipality == null ? null : municipality!.toJson(),
        "village": village == null ? null : village!.toJson(),
        "subDistrict": subDistrict == null ? null : subDistrict!.toJson(),
      };
}
