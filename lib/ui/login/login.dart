import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_app/common/validator.dart';
import 'package:form_app/ui/widget/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
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
              onPressed: () {},
              child: const Text('Conecte-se'),
            ),
          ],
        ),
      ),
    );
  }
}
