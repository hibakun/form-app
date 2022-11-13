// To parse this JSON data, do
//
//     final formtableModel = formtableModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

FormtableModel formtableModelFromJson(String str) =>
    FormtableModel.fromJson(json.decode(str));

String formtableModelToJson(FormtableModel data) => json.encode(data.toJson());

class FormtableModel {
  FormtableModel({
    required this.status,
    required this.messages,
    required this.counts,
    required this.data,
  });

  String status;
  List<String> messages;
  int counts;
  List<FormTableData> data;

  factory FormtableModel.fromJson(Map<String, dynamic> json) => FormtableModel(
        status: json["status"],
        messages: List<String>.from(json["messages"].map((x) => x)),
        counts: json["counts"],
        data: List<FormTableData>.from(
            json["data"].map((x) => FormTableData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "messages": List<dynamic>.from(messages.map((x) => x)),
        "counts": counts,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class FormTableData {
  FormTableData({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.formType,
  });

  int id;
  String code;
  String title;
  String description;
  String formType;

  factory FormTableData.fromJson(Map<String, dynamic> json) => FormTableData(
        id: json["id"],
        code: json["code"],
        title: json["title"],
        description: json["description"],
        formType: json["formType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "title": title,
        "description": description,
        "formType": formType,
      };
}

final String tableFormTable = 'formtable';

class FormFields {
  static final List<String> values = [
    idDb,
    id,
    code,
    title,
    description,
    formType
  ];
  static final String idDb = 'id';
  static final String id = 'idform';
  static final String code = 'code';
  static final String title = 'title';
  static final String description = 'description';
  static final String formType = 'formType';
}

class FormModel {
  final int? idDb;
  final int id;
  final String code;
  final String title;
  final String description;
  final String formType;

  FormModel(
      {this.idDb,
      required this.id,
      required this.code,
      required this.title,
      required this.description,
      required this.formType});

  static FormModel fromJson(Map<String, Object?> json) => FormModel(
      idDb: json[FormFields.idDb] as int?,
      id: json[FormFields.id] as int,
      code: json[FormFields.code] as String,
      title: json[FormFields.title] as String,
      description: json[FormFields.description] as String,
      formType: json[FormFields.formType] as String);

  Map<String, Object?> toJson() => {
        FormFields.idDb: idDb,
        FormFields.id: id,
        FormFields.code: code,
        FormFields.title: title,
        FormFields.description: description,
        FormFields.formType: formType
      };
  FormModel copy(
          {int? idDb,
          int? id,
          String? code,
          String? title,
          String? description,
          String? formType}) =>
      FormModel(
          idDb: idDb ?? this.idDb,
          id: id ?? this.id,
          code: code ?? this.code,
          title: title ?? this.title,
          description: description ?? this.description,
          formType: formType ?? this.formType);
}
