import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_app/common/validator.dart';
import 'package:form_app/model/loginModel.dart';
import 'package:form_app/service/api_service.dart';
import 'package:form_app/ui/test.dart';
import 'package:form_app/ui/widget/custom_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });
    if (_usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      LoginModel result = await ApiService().loginAPI(
          username: _usernameController.text,
          password: _passwordController.text);
      if (result.accessToken.isNotEmpty) {
        setState(() {
          _isLoading = false;
        });
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', result.accessToken);
        prefs.setString('user', result.username);
        Validator.navigatorReplacement(context, TestTheme());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(child: _buildLogin(context)),
          _isLoading
              ? Container(
                  color: Colors.white.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : SizedBox.shrink()
        ],
      ),
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
            controller: _usernameController,
            inputType: TextInputType.emailAddress,
            validator: (value) => Validator().emailValidator(value),
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
            controller: _passwordController,
            isPassword: true,
            validator: (value) => Validator().passwordValidator(value),
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
}
