import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_app/common/shared_code.dart';
import 'package:form_app/ui/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 50.h,
        title: Text("Perfil", style: TextStyle(fontSize: 20)),
        actions: [
          IconButton(
              onPressed: () {
                showAlertDialogLogout(context);
              },
              icon: Icon(
                Icons.logout,
                size: 20.h,
              )),
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 20.h),
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Image.asset(
                        'assets/logo.png',
                        width: 100.w,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text("Republica Democratica De Timor-Leste",
                              style: TextStyle(
                                  color: Colors.blue[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23)),
                        ),
                        SizedBox(height: 10.h),
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                              "Ministério da Solidariedade Social e Inclusão (MSSI)\nSistema Reprodusaun",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(
                thickness: 2,
                color: Colors.red,
              ),
              SizedBox(
                height: 50.h,
              ),
              SvgPicture.asset(
                'assets/profile.svg',
                width: 125.w,
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Admin',
                style: theme.headline1,
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                'admin@gmail.com',
                style: theme.bodyText1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  showAlertDialogLogout(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Não"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Sim"),
      onPressed: () async {
        final prefs = await SharedPreferences.getInstance();
        prefs.clear();
        SharedCode.navigatorPushAndRemove(context, LoginPage());
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Aviso"),
      content: Text("você quer sair?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
