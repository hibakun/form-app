import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_app/database/FormDb.dart';
import 'package:form_app/model/database/header.dart';
import 'package:form_app/model/database/question.dart';

class FillFormPage extends StatefulWidget {
  final String formType;

  const FillFormPage({Key? key, required this.formType}) : super(key: key);

  @override
  State<FillFormPage> createState() => _FillFormPageState();
}

class _FillFormPageState extends State<FillFormPage> {
  bool _isload = false;
  List<HeaderDatabaseModel> headers = [];
  List<QuestionDbModel> questions = [];

  read() async {
    setState(() {
      _isload = true;
    });
    headers = await FormTableDatabase.instance.readHeader(widget.formType);
    for (int i = 0; i < headers.length; i++) {
      print("form type : " + headers[i].formType.toString());
      print("form key : " + headers[i].key.toString());
      print("form value : " + headers[i].value.toString());
    }
    questions = await FormTableDatabase.instance.readQuestion(widget.formType);
    for (int i = 0; i < questions.length; i++) {
      print("form quesion : " + questions[i].question.toString());
    }

    setState(() {
      _isload = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isload
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Container(
                    height: 300.h,
                    child: ListView.builder(
                      itemCount: headers.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 3,
                          shadowColor: Colors.black,
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Text(headers[index].key.toString()),
                                Text(headers[index].value.toString()),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 300.h,
                    child: ListView.builder(
                      itemCount: questions.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 3,
                          shadowColor: Colors.black,
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Text(questions[index].input_type.toString()),
                                Text(questions[index].question.toString()),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ));
  }
}
