import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_app/model/database/content.dart';
import 'package:form_app/model/database/question_answer.dart';
import 'package:form_app/ui/dashboard/item/list_form.dart';
import 'package:form_app/ui/dashboard/item/update_form.dart';
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
              dropdownId: itemHeader[i].dropdownId,
              status: 0));
    }

    for (int i = 0; i < itemQuestion.length; i++) {
      await FormTableDatabase.instance.createQuestionAnswer(
          QuestionAnswerFields.questionanswerTable,
          QuestionAnswerDbModel(
            id_soal: itemQuestion[i].id_soal,
            formType: itemQuestion[i].formType,
            question: itemQuestion[i].question,
            answer: itemQuestion[i].answer,
            input_type: itemQuestion[i].input_type,
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 50.h,
        title: Text("Página inicial (preencher formulário)",
            style: TextStyle(fontSize: 20)),
      ),
      body: contentList.isEmpty
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/no_data.svg", width: 100.w),
                  SizedBox(height: 30.h),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text("Laiha Formulário\nDisponível",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25)),
                  ),
                ],
              ),
            )
          : isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return contentList[index].status == 0
                        ? Padding(
                            padding: EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => UpdateFormPage(
                                              code: contentList[index]
                                                  .code
                                                  .toString(),
                                            ))));
                              },
                              child: Card(
                                elevation: 4,
                                shadowColor: Colors.black,
                                child: ListTile(
                                  leading: IconButton(
                                      onPressed: () {
                                        showAlertDialogDuplicate(
                                            context, index);
                                      },
                                      icon: Icon(
                                        Icons.copy,
                                        size: 13.w,
                                      )),
                                  title: Text(
                                      contentList[index].code.toString()),
                                  subtitle: Text(
                                      contentList[index].formType.toString()),
                                  trailing: IconButton(
                                      onPressed: () async {
                                        showAlertDialogDelete(context, index);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        size: 13.w,
                                        color: Colors.red,
                                      )),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 4,
                              shadowColor: Colors.black,
                              child: ListTile(
                                leading: IconButton(
                                    onPressed: () {
                                      showAlertDialogDuplicate(
                                          context, index);
                                    },
                                    icon: Icon(
                                      Icons.copy,
                                      size: 13.w,
                                    )),
                                title:
                                    Text(contentList[index].code.toString()),
                                subtitle: Text(
                                  contentList[index].formType.toString() +
                                      " - Uploaded",
                                  style:
                                      TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ),
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
      ),
    );
  }

  showAlertDialogDuplicate(BuildContext context, int index) {
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
        isLoading = true;
        insert(contentList[index].code.toString());
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            // Here you can write your code for open new view
            read();
            isLoading = false;
          });
        });
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Aviso"),
      content: Text("Deseja copiar este item?"),
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

  showAlertDialogDelete(BuildContext context, int index) {
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
        isLoading = true;
        await FormTableDatabase.instance
            .deleteContent(contentList[index].code.toString());
        await FormTableDatabase.instance
            .deleteQuestion(contentList[index].code.toString());
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            // Here you can write your code for open new view
            read();
            isLoading = false;
          });
        });
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Aviso"),
      content: Text("Você quer apagar este item ?"),
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
