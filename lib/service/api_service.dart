import 'dart:convert';
import 'dart:io';

import 'package:form_app/model/loginModel.dart';
import 'package:form_app/service/server_config.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<LoginModel> loginAPI(
      {required String username, required String password}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final body = {"username": username, "password": password};
    print("RAW LOGIN: " + body.toString());
    print("URL LOGIN: " + ServerConfig.baseUrl + ServerConfig.loginUrl);
    final res = await http.post(
        Uri.parse(ServerConfig.baseUrl + ServerConfig.loginUrl),
        headers: headers,
        body: jsonEncode(body));
    print("STATUS CODE(LOGIN): " + res.statusCode.toString());
    print("RES LOGIN: " + res.body.toString());
    if (res.statusCode == 200) {
      return LoginModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }
}
