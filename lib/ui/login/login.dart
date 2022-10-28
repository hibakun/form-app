import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_app/common/shared_code.dart';
import 'package:form_app/model/login_model.dart';
import 'package:form_app/model/municipality_like_model.dart';
import 'package:form_app/model/municipality_model.dart';
import 'package:form_app/model/subdisctrict_by_muni_model.dart';
import 'package:form_app/model/subdisctrict_like_model.dart';
import 'package:form_app/model/subdisctrict_model.dart';
import 'package:form_app/model/subvillage_find_like.dart';
import 'package:form_app/model/subvillage_model.dart';
import 'package:form_app/model/village_by_sub_model.dart';
import 'package:form_app/model/village_like_model.dart';
import 'package:form_app/model/village_model.dart';
import 'package:form_app/service/api_service.dart';
import 'package:form_app/ui/dashboard/dashboard.dart';
import 'package:form_app/ui/widget/custom_text_field.dart';
import 'package:form_app/ui/widget/waringdialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isVisible = true;

  Future<void> _login() async {
    showWarningDialog("process",
        customMessage: "Carregando os dados.\nPode demorar alguns segundos");
    if (_usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      LoginModel result = await ApiService().loginAPI(
          username: _usernameController.text,
          password: _passwordController.text);
      if (result.accessToken.isNotEmpty) {
        Navigator.pop(context);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('pass', _passwordController.text);
        prefs.setString('user', result.username);
        SharedCode.navigatorReplacement(context, Dashboard());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: SingleChildScrollView(child: _buildLogin(context))),
    );
  }

  _buildLogin(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(35.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Conecte-se',
                style: theme.headline1,
              ),
            ),
            SizedBox(
              height: 7.h,
            ),
            SizedBox(
              height: 50.h,
            ),
            Text(
              'Conta',
              style: theme.bodyText1,
            ),
            SizedBox(
              height: 7.h,
            ),
            CustomTextField(
              isEnable: true,
              isreadOnly: false,
              controller: _usernameController,
              inputType: TextInputType.emailAddress,
              validator: (value) => SharedCode().emailValidator(value),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(
              height: 25.h,
            ),
            Text(
              'Senha',
              style: theme.bodyText1,
            ),
            SizedBox(
              height: 7.h,
            ),
            CustomTextField(
              inputType: TextInputType.text,
              isEnable: true,
              isreadOnly: false,
              controller: _passwordController,
              isPassword: _isVisible,
              validator: (value) => SharedCode().passwordValidator(value),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isVisible ? Icons.visibility_off : Icons.visibility,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    setState(() {
                      _isVisible = !_isVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 35.h,
            ),
            ElevatedButton(
              onPressed: () {
                if (_usernameController.text == "admin@gmail.com" &&
                    _passwordController.text == "admin77") {
                  _login();
                } else if (_usernameController.text.isEmpty &&
                    _passwordController.text.isEmpty) {
                  showWarningDialog("error",
                      customMessage: "Usuário/senha vazio");
                } else {
                  showWarningDialog("error",
                      customMessage: "Usuário/senha não corresponde");
                }
              },
              child: const Text('Conecte-se'),
            ),
          ],
        ),
      ),
    );
  }

  void showWarningDialog(String type, {required String customMessage}) {
    String dialogType = "";
    String title = "";
    String message = "";
    IconData icon = Icons.warning;

    switch (type) {
      case "warning":
        dialogType = "warning";
        title = "Review";
        message = customMessage;
        icon = Icons.warning;
        break;
      case "process":
        dialogType = "process";
        title = "Process";
        message = customMessage;
        icon = Icons.hourglass_bottom;
        break;
      case "succeed":
        dialogType = "succeed";
        title = "Succeed";
        message = "Successfully";
        icon = Icons.check_circle_outline;
        break;
      case "error":
        dialogType = "error";
        message = customMessage;
        title = "Error";
        icon = Icons.error;
        break;
      default:
    }
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => new Dialog(
                child: WarningDialog(
              type: dialogType,
              title: title,
              message: message,
              icon: icon,
            )));
  }
}
