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
  List<QuestionAnswerDbModel> questionAnswerList = [];
  List<ContentDatabaseModel> itemHeader = [];
  List<QuestionAnswerDbModel> itemQuestion = [];

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
  }

  Future insert(String code) async {
    itemHeader = await FormTableDatabase.instance.readContent(code);
    print('ITEM HEADER : ${itemHeader.length}');
    itemQuestion = await FormTableDatabase.instance.readQuestionAnswer(code);
    print('ITEM QUESTION : ${itemQuestion.length}');
    Random random = Random();
    int randomNumber = random.nextInt(900) + 100;
    String date = DateFormat('ddMMyyyy').format(DateTime.now());
    String result = '${itemHeader[0].formType}-$date-$randomNumber';

    for (int i = 0; i < itemHeader.length; i++) {
      await FormTableDatabase.instance.createContent(
          ContentFields.table,
          ContentDatabaseModel(
            formType: itemHeader[i].formType,
            key: itemHeader[i].key,
            value: itemHeader[i].value,
            code: result,
          ));
    }

    for (int i = 0; i < itemQuestion.length; i++) {
      await FormTableDatabase.instance.createQuestionAnswer(
          QuestionAnswerFields.questionanswerTable,
          QuestionAnswerDbModel(
            id_soal: itemQuestion[i].id_soal,
            formType: itemQuestion[i].formType,
            question: itemQuestion[i].question,
            answer: itemQuestion[i].answer,
            dropdown: itemQuestion[i].dropdown,
            code: result,
          ));
    }

    readContentList.clear();
    questionAnswerList.clear();
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
      body: contentList.isEmpty
          ? Center(
              child: Text("Nenhum formulário adicionado ainda"),
            )
          : isLoading
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
                            await FormTableDatabase.instance.deleteQuestion(
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
                  MaterialPageRoute(builder: ((context) => ListFormPage())))
              .then((value) => read());
        },
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
