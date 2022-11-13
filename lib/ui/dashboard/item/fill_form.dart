import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_app/common/shared_code.dart';
import 'package:form_app/common/string_extension.dart';
import 'package:form_app/database/FormDb.dart';
import 'package:form_app/model/database/header.dart';
import 'package:form_app/model/database/municipality.dart';
import 'package:form_app/model/database/question.dart';
import 'package:form_app/model/database/question_answer.dart';
import 'package:form_app/model/database/subdistrict.dart';
import 'package:form_app/model/database/subvillage.dart';
import 'package:form_app/model/database/village.dart';
import 'package:form_app/model/municipality_model.dart';
import 'package:form_app/model/subdisctrict_by_muni_model.dart';
import 'package:form_app/model/subdisctrict_model.dart';
import 'package:form_app/model/subvillage_by_vill_model.dart';
import 'package:form_app/model/subvillage_model.dart';
import 'package:form_app/model/surveyFormDownloadModel.dart';
import 'package:form_app/model/village_by_sub_model.dart';
import 'package:form_app/service/api_service.dart';
import 'package:form_app/ui/dashboard/dashboard.dart';
import 'package:form_app/ui/dashboard/item/add_form.dart';
import 'package:form_app/ui/widget/custom_text_field.dart';
import 'package:intl/intl.dart';

import '../../../model/database/content.dart';

class FillFormPage extends StatefulWidget {
  final String formType;

  const FillFormPage({Key? key, required this.formType}) : super(key: key);

  @override
  State<FillFormPage> createState() => _FillFormPageState();
}

class _FillFormPageState extends State<FillFormPage> {
  MunicipalityDatabaseModel? dropdownMunicipality = null;
  SubdistrictDatabaseModel? dropdownsubDistrict = null;
  VillageDatabaseModel? dropdownVillage = null;
  SubVillageDatabaseModel? dropdownsubVillage = null;
  List<SubdistrictDatabaseModel> subDistrictList = [];
  List<VillageDatabaseModel> villageList = [];
  List<SubVillageDatabaseModel> subVillageList = [];
  List<SurveyLine> surveyLinesList = [];

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  DateTime _selectedDate = DateTime.now();
  String _selectDate = "";
  final _interviewerController = TextEditingController();
  bool _isload = false;
  bool _isloading = false;
  bool _showsubDistrict = false;
  bool _showvillage = false;
  bool _showsubVillage = false;
  List<HeaderDatabaseModel> headers = [];
  List<QuestionDbModel> questions = [];
  List<MunicipalityDatabaseModel> municipalityList = [];
  List freeTextQuestion = [];
  List dropdown = [];
  List dropdownSplit = [];
  List dropdownQuestion = [];
  List questionIdFreeText = [];
  List questionIdChoice = [];

  List selectVal = [];
  final Map<String, dynamic> answersFreeTextMap = {};
  final Map<String, dynamic> answersChoiceMap = {};

  var municipalityValue;
  var municipalityId;
  var municipalityCode;
  var subDistrictValue;
  var subDistrictCode;
  var subDistrictId;
  var villageValue;
  var villageId;
  var villageCode;
  var subVillageValue;
  var subVillageId;

  read() async {
    setState(() {
      _isloading = true;
    });

    municipalityList = await FormTableDatabase.instance.readMunicipality();
    for (int i = 0; i < municipalityList.length; i++){
      print("name: " + municipalityList[i].name.toString());
      print("name: " + municipalityList[i].kode_municipality.toString());
    }


    headers = await FormTableDatabase.instance.readHeader(widget.formType);
    for (int i = 0; i < headers.length; i++) {
      print("form type : " + headers[i].formType.toString());
      print("form key : " + headers[i].key.toString());
      print("form value : " + headers[i].value.toString());
    }
    questions = await FormTableDatabase.instance.readQuestion(widget.formType);
    for (int i = 0; i < questions.length; i++) {
      print("Question IDS: " + questions[i].kode_soal.toString());
      if (questions[i].dropdown.toString() == "") continue;
      questionIdChoice.add(questions[i].kode_soal);
      print("Question IDS continue: " + questions[i].kode_soal.toString());
      dropdown.add(questions[i].dropdown.toString());
    }

    questionIdChoice.forEach((element) {
      print(element.toString());
    });

    for (int i = 0; i < questions.length; i++) {
      print("QUESTION CHOICE: " + questions[i].question.toString());
      if (questions[i].input_type == "FreeText") continue;
      dropdownQuestion.add(questions[i].question.toString());
      print("INPUT TYPE: " + questions[i].input_type.toString());
    }

    for (int i = 0; i < questions.length; i++) {
      print("QUESTION FREETEXT: " + questions[i].question.toString());
      if (questions[i].input_type == "Choice") continue;
      questionIdFreeText.add(questions[i].kode_soal);
      answersFreeTextMap[questions[i].question.toString()] = "0";
      print("FREE TEXT MAP: " + answersFreeTextMap.toString());
      freeTextQuestion.add(questions[i].question.toString());
    }

    for (int i = 0; i < dropdown.length; i++) {
      print("DROPDOWNS: " + dropdown[i]);
      dropdownSplit.add(dropdown[i].split("Îµ"));
    }

    dropdownSplit.forEach((element) {
      print("SPLITTED DROPDOWN: " + element.toString());
    });

    for (int i = 0; i < dropdownSplit.length; i++) {
      selectVal.add(dropdownSplit[i][0]);
      print("SELECT VALUE: " + selectVal.toString());
    }

    for (int i = 0; i < selectVal.length; i++) {
      answersChoiceMap[dropdownQuestion[i]] = selectVal[i];
      print("Choice MAP: " + answersChoiceMap.toString());
    }

    for (int i = 0; i < dropdown.length; i++) {
      print("QUESTION: " + questions[i].question.toString());
      if (questions[i].input_type != "Choice") continue;
      dropdownQuestion.add(questions[i].question.toString());
      print("SPLITTED DROPDOWN QUESTION: " + dropdownQuestion[i].toString());
    }

    setState(() {
      _isloading = false;
    });
  }

  String _randomCode() {
    Random random = Random();
    int randomNumber = random.nextInt(900) + 100;
    String date = DateFormat('ddMMyyyy').format(DateTime.now());

    String result = '${headers[0].formType}-$date-$randomNumber';
    return result;
  }

  Future addContent() async {
    String code = _randomCode();

    await FormTableDatabase.instance.createContent(
        ContentFields.table,
        ContentDatabaseModel(
            formType: headers[0].formType.toString(),
            key: "title",
            value: headers[0].value,
            code: code,
            status: 0,
            dropdownId: null));

    await FormTableDatabase.instance.createContent(
        ContentFields.table,
        ContentDatabaseModel(
            formType: headers[0].formType.toString(),
            key: "description",
            value: headers[1].value,
            code: code,
            status: 0,
            dropdownId: null));

    await FormTableDatabase.instance.createContent(
        ContentFields.table,
        ContentDatabaseModel(
            formType: headers[0].formType.toString(),
            key: headers[2].key,
            value: _selectDate,
            code: code,
            status: 0,
            dropdownId: null));

    await FormTableDatabase.instance.createContent(
        ContentFields.table,
        ContentDatabaseModel(
            formType: headers[0].formType.toString(),
            key: headers[3].key,
            value: municipalityValue,
            code: code,
            status: 0,
            dropdownId: municipalityId));

    await FormTableDatabase.instance.createContent(
        ContentFields.table,
        ContentDatabaseModel(
            formType: headers[0].formType.toString(),
            key: headers[4].key,
            value: subDistrictValue,
            code: code,
            status: 0,
            dropdownId: subDistrictId));

    await FormTableDatabase.instance.createContent(
        ContentFields.table,
        ContentDatabaseModel(
            formType: headers[0].formType.toString(),
            key: headers[5].key,
            value: villageValue,
            code: code,
            status: 0,
            dropdownId: villageId));
    print("VILLAGE ID: " + villageId.toString());

    await FormTableDatabase.instance.createContent(
        ContentFields.table,
        ContentDatabaseModel(
            formType: headers[0].formType.toString(),
            key: headers[6].key,
            value: subVillageValue,
            code: code,
            status: 0,
            dropdownId: subVillageId));

    await FormTableDatabase.instance.createContent(
        ContentFields.table,
        ContentDatabaseModel(
            formType: headers[0].formType.toString(),
            key: headers[7].key,
            value: _interviewerController.text,
            code: code,
            status: 0,
            dropdownId: null));

    print("FREE TEXT MAP SAVED: " + answersFreeTextMap.toString());
    print("Choice MAP SAVED: " + answersChoiceMap.toString());
    int indexFreeText = 0;
    answersFreeTextMap.forEach((key, value) {
      print('QUESTION ID FREE TEXT : ' +
          questionIdFreeText[indexFreeText].toString());
      FormTableDatabase.instance.createQuestionAnswer(
          QuestionAnswerFields.questionanswerTable,
          QuestionAnswerDbModel(
              id_soal: questionIdFreeText[indexFreeText],
              formType: headers[0].formType.toString(),
              question: key,
              answer: value,
              input_type: "FreeText",
              code: code,
              dropdown: ""));

      indexFreeText++;
    });

    int indexChoice = 0;
    answersChoiceMap.forEach((key, value) {
      print('QUESTION ID CHOICE : ' + questionIdChoice[indexChoice].toString());
      FormTableDatabase.instance.createQuestionAnswer(
          QuestionAnswerFields.questionanswerTable,
          QuestionAnswerDbModel(
              id_soal: questionIdChoice[indexChoice],
              formType: headers[0].formType.toString(),
              question: key,
              answer: value,
              code: code,
              input_type: "Choice",
              dropdown: dropdown[indexChoice]));
      indexChoice++;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (dropdown.isNotEmpty) {
      freeTextQuestion.clear();
      dropdown.clear();
      dropdownSplit.clear();
      dropdownQuestion.clear();
      selectVal.clear();
    }
    _selectDate = _dateFormat.format(_selectedDate);
    read();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 50.h,
            title: Text("Formulário " + widget.formType + " de pesquisa",
                style: TextStyle(fontSize: 20)),
          ),
          body: _isloading
              ? Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _headerForm(),
                          _bodyFormFreeText(),
                          _bodyFormChoice(),
                          _buttonSave()
                        ],
                      ),
                    ),
                    _isload
                        ? Container(
                            color: Colors.white.withOpacity(0.5),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : SizedBox.shrink()
                  ],
                )),
    );
  }

  Widget _buildDatePickerField() {
    return InkWell(
      onTap: () {
        _showDatePicker(context);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
        height: 40.h,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(_selectDate.toString(), style: TextStyle(fontSize: 14)),
              SizedBox(
                width: 10.w,
              ),
              Icon(Icons.arrow_drop_down)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );

    setState(() {
      if (selected != null && selected != _selectedDate) {
        _selectedDate = selected;
        _selectDate = _dateFormat.format(selected);
      }
    });
  }

  _buildDropdownMunicipality() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(headers[3].key.toString().capitalize() + " : ",
              style: TextStyle(fontSize: 15)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(5)),
              child: DropdownButton<MunicipalityDatabaseModel>(
                isExpanded: true,
                value: dropdownMunicipality,
                icon: Icon(Icons.arrow_drop_down),
                onChanged: (MunicipalityDatabaseModel? value) async {
                  if(dropdownMunicipality != null){
                    setState(() {
                      _isload = true;
                    });
                    municipalityValue = value?.name;
                    municipalityId = value?.id_dropdown;
                    municipalityCode = value?.kode_municipality;
                    subDistrictList = await FormTableDatabase.instance.readSubdistrict(municipalityCode);
                    setState(() {
                      dropdownMunicipality = value;
                      dropdownsubDistrict = null;
                      dropdownVillage = null;
                      dropdownsubVillage = null;
                      _showsubDistrict = true;
                      _showvillage = false;
                      _showsubVillage = false;
                      _isload = false;
                    });
                  } else {
                    setState(() {
                      _isload = true;
                    });
                    municipalityValue = value?.name;
                    municipalityId = value?.id_dropdown;
                    municipalityCode = value?.kode_municipality;
                    subDistrictList = await FormTableDatabase.instance.readSubdistrict(municipalityCode);
                    setState(() {
                      _showsubDistrict = true;
                      _isload = false;
                      dropdownMunicipality = value;
                    });
                  }
                },
                isDense: true,
                underline: SizedBox.shrink(),
                items: municipalityList.map((MunicipalityDatabaseModel item) {
                  return DropdownMenuItem<MunicipalityDatabaseModel>(
                    child: Text(
                      item.name.toString(),
                      style: TextStyle(fontSize: 17),
                    ),
                    value: item,
                  );
                }).toList(),
              )),
        ),
        _showsubDistrict ? _buildDropdownsubDistrict() : Container()
      ],
    );
  }

  _buildDropdownsubDistrict() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(headers[4].key.toString().capitalize().replaceAll("_", " ") + " : ",
              style: TextStyle(fontSize: 15)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(5)),
              child: DropdownButton<SubdistrictDatabaseModel>(
                isExpanded: true,
                value: dropdownsubDistrict,
                icon: Icon(Icons.arrow_drop_down),
                onChanged: (SubdistrictDatabaseModel? newValue) async {
                  if (dropdownsubDistrict != null) {
                    setState(() {
                      _isload = true;
                    });
                    subDistrictValue = newValue!.name;
                    subDistrictCode = newValue.kode_subdistrict;
                    subDistrictId = newValue.id_dropdown;
                    villageList = await FormTableDatabase.instance.readVillage(subDistrictCode);
                    setState(() {
                      dropdownsubDistrict = newValue;
                      dropdownVillage = null;
                      dropdownsubVillage = null;
                      _showsubDistrict = true;
                      _showvillage = true;
                      _showsubVillage = false;
                      _isload = false;
                    });
                  } else {
                    setState(() {
                      _isload = true;
                    });
                    subDistrictValue = newValue!.name;
                    subDistrictId = newValue.id;
                    subDistrictCode = newValue.kode_subdistrict;
                    villageList = await FormTableDatabase.instance.readVillage(subDistrictCode);
                    setState(() {
                      dropdownsubDistrict = newValue;
                      _showvillage = true;
                      _isload = false;
                    });
                  }
                },
                isDense: true,
                underline: SizedBox.shrink(),
                items: subDistrictList.map((SubdistrictDatabaseModel item) {
                  return DropdownMenuItem<SubdistrictDatabaseModel>(
                    child: Text(
                      item.name.toString(),
                      style: TextStyle(fontSize: 17),
                    ),
                    value: item,
                  );
                }).toList(),
              )),
        ),
        _showvillage ? _buildDropdownVillage() : Container()
      ],
    );
  }

  _buildDropdownVillage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(headers[5].key.toString().capitalize() + " : ",
              style: TextStyle(fontSize: 15)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(5)),
              child: DropdownButton<VillageDatabaseModel>(
                isExpanded: true,
                value: dropdownVillage,
                icon: Icon(Icons.arrow_drop_down),
                onChanged: (VillageDatabaseModel? newValue) async {
                  if (dropdownVillage != null) {
                    setState(() {
                      _isload = true;
                    });
                    villageValue = newValue!.name;
                    villageId = newValue.id;
                    villageCode = newValue.kode_village;
                    subVillageList = await FormTableDatabase.instance.readSubVillage(villageCode);
                    _showsubDistrict = true;
                    _showvillage = true;
                    _showsubVillage = true;
                    setState(() {
                      dropdownsubVillage = null;
                      dropdownVillage = newValue;
                      _isload = false;
                    });
                  } else {
                    setState(() {
                      _isload = true;
                    });
                    villageValue = newValue!.name;
                    villageId = newValue.id;
                    villageCode = newValue.kode_village;
                    subVillageList = await FormTableDatabase.instance.readSubVillage(villageCode);
                    setState(() {
                      dropdownVillage = newValue;
                      _showsubVillage = true;
                      _isload = false;
                    });
                  }
                },
                isDense: true,
                underline: SizedBox.shrink(),
                items: villageList.map((VillageDatabaseModel item) {
                  return DropdownMenuItem<VillageDatabaseModel>(
                    child: Text(
                      item.name.toString(),
                      style: TextStyle(fontSize: 17),
                    ),
                    value: item,
                  );
                }).toList(),
              )),
        ),
        _showsubVillage ? _buildDropdownsubVillage() : Container()
      ],
    );
  }

  _buildDropdownsubVillage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(headers[6].key.toString().capitalize() + " : ",
              style: TextStyle(fontSize: 15)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(5)),
              child: DropdownButton<SubVillageDatabaseModel>(
                isExpanded: true,
                value: dropdownsubVillage,
                icon: Icon(Icons.arrow_drop_down),
                onChanged: (SubVillageDatabaseModel? newValue) {
                  setState(() {
                    subVillageValue = newValue!.name;
                    subVillageId = newValue.id;
                    dropdownsubVillage = newValue;
                  });
                },
                isDense: true,
                underline: SizedBox.shrink(),
                items: subVillageList.map((SubVillageDatabaseModel item) {
                  return DropdownMenuItem<SubVillageDatabaseModel>(
                    child: Text(
                      item.name.toString(),
                      style: TextStyle(fontSize: 17),
                    ),
                    value: item,
                  );
                }).toList(),
              )),
        ),
      ],
    );
  }

  _headerForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 25),
          child: Center(
              child: Text(headers[0].value.toString(),
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Center(
              child: Text(headers[1].value.toString(),
                  style: TextStyle(fontSize: 15), textAlign: TextAlign.center)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
              headers[2].key.toString().capitalize().replaceAll("_", " ") + " :",
              style: TextStyle(fontSize: 15)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: _buildDatePickerField(),
        ),
        _buildDropdownMunicipality(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(headers[7].key.toString().capitalize().replaceAll("_", " ") + " :",
              style: TextStyle(fontSize: 15)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: CustomTextField(
            isEnable: true,
            isreadOnly: false,
            controller: _interviewerController,
            inputType: TextInputType.text,
            validator: (value) => SharedCode().emptyValidator(value),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _bodyFormChoice() {
    return Column(
      children: List<Widget>.generate(dropdown.length, (int index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(dropdownQuestion[index].toString() + " :",
                  style: TextStyle(fontSize: 15)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(5)),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: selectVal[index],
                    icon: Icon(Icons.arrow_drop_down),
                    onChanged: (value) {
                      setState(() {
                        selectVal[index] = value!;
                        answersChoiceMap[dropdownQuestion[index].toString()] =
                            selectVal[index];
                        print(answersChoiceMap);
                      });
                    },
                    isDense: true,
                    underline: SizedBox.shrink(),
                    items: dropdown[index]
                        .split("Îµ")
                        .map<DropdownMenuItem<String>>((e) {
                      return DropdownMenuItem<String>(
                        value: e,
                        child: Text(utf8.decode(e.runes.toList()),
                            style: TextStyle(fontSize: 17)),
                      );
                    }).toList(),
                  )),
            ),
          ],
        );
      }),
    );
  }

  _bodyFormFreeText() {
    return Column(
      children: List<Widget>.generate(freeTextQuestion.length, (int index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(freeTextQuestion[index].toString() + " :",
                  style: TextStyle(fontSize: 15)),
            ),
            FocusTraversalGroup(
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                onChanged: () {
                  Form.of(primaryFocus!.context!)!.save();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    style: Theme.of(context).textTheme.bodyText1,
                    validator: (value) => SharedCode().emptyValidator(value),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (String? value) {
                      print('Value for field $index saved as "$value"');
                      print('Question Text: ' +
                          freeTextQuestion[index].toString());
                      answersFreeTextMap[freeTextQuestion[index].toString()] =
                          value;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  _buttonSave() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      child: Center(
        child: Container(
          height: 40.h,
          width: 200.w,
          child: ElevatedButton(
              onPressed: () {
                showAlertDialogSave(context);
              },
              child: Text("Salvar",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue))),
        ),
      ),
    );
  }

  showAlertDialogSave(BuildContext context) {
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
        print(answersFreeTextMap);
        await addContent();
        if (!mounted) return;
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Aviso"),
      content: Text("Deseja salvar sua resposta ?"),
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
