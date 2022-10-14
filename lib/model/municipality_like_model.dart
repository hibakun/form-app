// To parse this JSON data, do
//
//     final municipalityLikeModel = municipalityLikeModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

MunicipalityLikeModel municipalityLikeModelFromJson(String str) =>
    MunicipalityLikeModel.fromJson(json.decode(str));

String municipalityLikeModelToJson(MunicipalityLikeModel data) =>
    json.encode(data.toJson());

class MunicipalityLikeModel {
  MunicipalityLikeModel({
    required this.status,
    required this.messages,
    required this.counts,
    required this.data,
  });

  String status;
  List<String> messages;
  int counts;
  List<MunicipalityLikeData> data;

  factory MunicipalityLikeModel.fromJson(Map<String, dynamic> json) =>
      MunicipalityLikeModel(
        status: json["status"],
        messages: List<String>.from(json["messages"].map((x) => x)),
        counts: json["counts"],
        data: List<MunicipalityLikeData>.from(
            json["data"].map((x) => MunicipalityLikeData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "messages": List<dynamic>.from(messages.map((x) => x)),
        "counts": counts,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class MunicipalityLikeData {
  MunicipalityLikeData({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
  });

  int id;
  String code;
  String name;
  String description;

  factory MunicipalityLikeData.fromJson(Map<String, dynamic> json) =>
      MunicipalityLikeData(
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
