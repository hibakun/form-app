import 'dart:math';

import 'package:flutter/material.dart';
import 'package:form_app/model/database/content.dart';
import 'package:form_app/model/database/question_answer.dart';
import 'package:form_app/ui/dashboard/item/list_form.dart';
import 'package:intl/intl.dart';

import '../../../database/FormDb.dart';

class AddFormPage extends StatefulWidget {
  const AddFormPage({Key? key}) : super(key: key);

  @override
  State<AddFormPage> createState() => _AddFormPageState();
}

class _AddFormPageState extends State<AddFormPage> {
  List<ContentDatabaseModel> contentList = [];
  List<ContentDatabaseModel> readContentList = [];
  List<QuestionAnswerDbModel> questionList = [];

  bool isLoading = false;

  Future read() async {

    setState(() {
      isLoading = true;
    });
    contentList = await FormTableDatabase.instance.contentReadAll();
    questionList = await FormTableDatabase.instance.readQuestionAnswerAll();
    setState(() {
      isLoading = false;
    });
    questionList.forEach((element) {
      print("QUESTION LIST: " + element.kode_soal.toString());
    });
  }



  Future insert(String code) async{
    readContentList = await FormTableDatabase.instance.readContent(code);
    Random random = Random();
    int randomNumber = random.nextInt(900) + 100;
    String date = DateFormat('ddMMyyyy').format(DateTime.now());
    String result = '${readContentList[0].formType}-$date-$randomNumber';
    await FormTableDatabase.instance.createContent(
        ContentFields.table,
        ContentDatabaseModel(
          formType: readContentList[0].formType,
          key: readContentList[0].key,
          value: readContentList[0].value,
          code: result,
        ));
    readContentList.clear();
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
      body: contentList.isEmpty ? Center(child: Text("Nenhum formulário adicionado ainda"),) :isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: IconButton(
                      onPressed: () async {
                        isLoading = true;
                        insert(contentList[index].code.toString());
                        Future.delayed(const Duration(milliseconds: 500),
                                () {
                              setState(() {
                                // Here you can write your code for open new view
                                read();
                                isLoading = false;
                              });
                            });
                      },
                      icon: Icon(
                        Icons.copy,
                      )),
                  title: Text(contentList[index].code.toString()),
                  subtitle: Text(contentList[index].formType.toString()),
                  trailing: IconButton(
                          onPressed: () async {
                            isLoading = true;
                            await FormTableDatabase.instance.deleteContent(
                                contentList[index].code.toString());
                            Future.delayed(const Duration(milliseconds: 500),
                                () {
                              setState(() {
                                // Here you can write your code for open new view
                                read();
                                isLoading = false;
                              });
                            });
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                );
              },
              itemCount: contentList.length,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => ListFormPage())));
        },
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
