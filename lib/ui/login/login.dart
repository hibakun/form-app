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
import 'package:form_app/ui/test.dart';
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

  Future<void> _login() async {
    showWarningDialog("process",
        customMessage: "Loading the data.\nIt may take a few seconds");
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
      body: SingleChildScrollView(child: _buildLogin(context)),
    );
  }

  _buildLogin(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    return Container(
      margin: EdgeInsets.only(top: 100.h),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Conecte-se',
            style: theme.headline1,
          ),
          SizedBox(
            height: 7.h,
          ),
          Text(
            'Faça login para continuar.',
            style: theme.subtitle1,
          ),
          SizedBox(
            height: 50.h,
          ),
          Text(
            'Nome de usuário',
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
            isEnable: true,
            isreadOnly: false,
            controller: _passwordController,
            isPassword: true,
            validator: (value) => SharedCode().passwordValidator(value),
          ),
          SizedBox(
            height: 35.h,
          ),
          ElevatedButton(
            onPressed: () {
              _login();
            },
            child: const Text('Conecte-se'),
          ),
        ],
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
