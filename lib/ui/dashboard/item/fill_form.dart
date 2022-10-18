import 'package:flutter/material.dart';
import 'package:form_app/database/FormDb.dart';
import 'package:form_app/model/database/header.dart';

class FillFormPage extends StatefulWidget {
  final String formType;

  const FillFormPage({Key? key, required this.formType}) : super(key: key);

  @override
  State<FillFormPage> createState() => _FillFormPageState();
}

class _FillFormPageState extends State<FillFormPage> {
  var data;
  
  
  read() async{
    print(data);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.formType);
    read();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("adadwe"),
      ),
    );
  }
}
