// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    required this.tokenType,
    required this.username,
    required this.accessToken,
    required this.time,
  });

  String tokenType;
  String username;
  String accessToken;
  int time;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        tokenType: json["token_type"],
        username: json["username"],
        accessToken: json["access_token"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "token_type": tokenType,
        "username": username,
        "access_token": accessToken,
        "time": time,
      };
}
