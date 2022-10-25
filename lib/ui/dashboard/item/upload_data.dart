import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../database/FormDb.dart';
import '../../../model/database/content.dart';
import '../../../model/database/question_answer.dart';

class UploadDataPage extends StatefulWidget {
  const UploadDataPage({Key? key}) : super(key: key);

  @override
  State<UploadDataPage> createState() => _UploadDataPageState();
}

class _UploadDataPageState extends State<UploadDataPage> {
  List<QuestionAnswerDbModel> questionList = [];
  List<ContentDatabaseModel> contentList = [];
  List<ContentDatabaseModel> readContent = [];
  List<QuestionAnswerDbModel> readQuestion = [];
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

  upload() async {
    String tdata = DateFormat("hh:mm:ss").format(DateTime.now());
    String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    var header = Map<String, String>();
    final prefs = await SharedPreferences.getInstance();
    var deviceId = prefs.getString('deviceId');
    var surveyTable = Map<String, dynamic>();
    List<String> listQuestion = [];
    var question = Map<String, String>();
    var dtoForm = Map<String, dynamic>();
    for (int i = 0; i < contentList.length; i++) {
      readContent =
          await FormTableDatabase.instance.readContent(contentList[i].code);
      for (int p = 0; p < readContent.length; p++) {
        header[readContent[p].key.toString()] = readContent[p].value.toString();
      }
      readQuestion =
      await FormTableDatabase.instance.readQuestionAnswer(contentList[i].code);
      readQuestion.forEach((element) {
        question["id"] = element.id_soal.toString();
        question["inputType"] = element.input_type.toString();
        question["question"] = element.question.toString();
        question["dropDown"] = element.dropdown.toString();

        dtoForm["dtoFormLine"] = question;
        dtoForm["userInput"] = element.answer;
        dtoForm["transTime"] = tdata;
        print("dtoForm: " + dtoForm.toString());
        listQuestion.add(dtoForm.toString());
      });
      header["transId"] = readQuestion[i].code.toString();
      header["transTime"] = tdata;
      header["transDate"] = cdate;
      header["deviceId"] = deviceId.toString();
      surveyTable["surveyTable"] = header;
      surveyTable["surveyLines"] = listQuestion;
      print(surveyTable.toString());
      //post disini

    }
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Página inicial (Enviar formulário)"),
      ),
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
                    return InkWell(
                      onTap: () {},
                      child: ListTile(
                        title: Text(contentList[index].code.toString()),
                        subtitle: Text(contentList[index].formType.toString()),
                      ),
                    );
                  },
                  itemCount: contentList.length,
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          upload();
        },
        child: Icon(Icons.upload),
      ),
    );
  }
}
