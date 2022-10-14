// To parse this JSON data, do
//
//     final municipalityModel = municipalityModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

MunicipalityModel municipalityModelFromJson(String str) =>
    MunicipalityModel.fromJson(json.decode(str));

String municipalityModelToJson(MunicipalityModel data) =>
    json.encode(data.toJson());

class MunicipalityModel {
  MunicipalityModel({
    required this.status,
    required this.messages,
    required this.counts,
    required this.data,
  });

  String status;
  List<String> messages;
  int counts;
  List<MunicipalityData> data;

  factory MunicipalityModel.fromJson(Map<String, dynamic> json) =>
      MunicipalityModel(
        status: json["status"],
        messages: List<String>.from(json["messages"].map((x) => x)),
        counts: json["counts"],
        data: List<MunicipalityData>.from(
            json["data"].map((x) => MunicipalityData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "messages": List<dynamic>.from(messages.map((x) => x)),
        "counts": counts,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class MunicipalityData {
  MunicipalityData({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
  });

  int id;
  String code;
  String name;
  String description;

  factory MunicipalityData.fromJson(Map<String, dynamic> json) =>
      MunicipalityData(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "description": description,
      };
}
