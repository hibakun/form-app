// To parse this JSON data, do
//
//     final subVillageLikeModel = subVillageLikeModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SubVillageLikeModel subVillageLikeModelFromJson(String str) => SubVillageLikeModel.fromJson(json.decode(str));

String subVillageLikeModelToJson(SubVillageLikeModel data) => json.encode(data.toJson());

class SubVillageLikeModel {
  SubVillageLikeModel({
    required this.status,
    required this.messages,
    required this.counts,
    required this.data,
  });

  String status;
  List<String> messages;
  int counts;
  List<SubVillageLike> data;

  factory SubVillageLikeModel.fromJson(Map<String, dynamic> json) => SubVillageLikeModel(
    status: json["status"],
    messages: List<String>.from(json["messages"].map((x) => x)),
    counts: json["counts"],
    data: List<SubVillageLike>.from(json["data"].map((x) => SubVillageLike.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "messages": List<dynamic>.from(messages.map((x) => x)),
    "counts": counts,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class SubVillageLike {
  SubVillageLike({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.village,
    required this.subDistrict,
    required this.municipality,
  });

  int id;
  String code;
  String name;
  String description;
  SubVillageLike? village;
  SubVillageLike? subDistrict;
  SubVillageLike? municipality;

  factory SubVillageLike.fromJson(Map<String, dynamic> json) => SubVillageLike(
    id: json["id"],
    code: json["code"],
    name: json["name"],
    description: json["description"],
    village: json["village"] == null ? null : SubVillageLike.fromJson(json["village"]),
    subDistrict: json["subDistrict"] == null ? null : SubVillageLike.fromJson(json["subDistrict"]),
    municipality: json["municipality"] == null ? null : SubVillageLike.fromJson(json["municipality"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "name": name,
    "description": description,
    "village": village == null ? null : village!.toJson(),
    "subDistrict": subDistrict == null ? null : subDistrict!.toJson(),
    "municipality": municipality == null ? null : municipality!.toJson(),
  };
}
