import 'dart:math';

import 'package:dob_input_field/dob_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_app/common/shared_code.dart';
import 'package:form_app/database/FormDb.dart';
import 'package:form_app/model/database/header.dart';
import 'package:form_app/model/database/question.dart';
import 'package:form_app/model/database/question_answer.dart';
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

class UpdateFormPage extends StatefulWidget {
  final String code;

  const UpdateFormPage({Key? key, required this.code}) : super(key: key);

  @override
  State<UpdateFormPage> createState() => _UpdateFormPageState();
}

class _UpdateFormPageState extends State<UpdateFormPage> {
  MunicipalityData? dropdownMunicipality = null;
  SubdisctrictByMuniData? dropdownsubDistrict = null;
  VillageBySubData? dropdownVillage = null;
  SubvillageByVillageData? dropdownsubVillage = null;
  List<MunicipalityData> municipalityList = [];
  List<MunicipalityData> municipalityListInitVal = [];
  List<SubdisctrictByMuniData> subDistrictList = [];
  List<VillageBySubData> villageList = [];
  List<SubvillageByVillageData> subVillageList = [];
  List<SurveyLine> surveyLinesList = [];

  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  DateTime _selectedDate = DateTime.now();
  String _selectDate = "";
  final _nameController = TextEditingController();
  final _questionsController = TextEditingController();
  final _interviewerController = TextEditingController();
  final _headVillageController = TextEditingController();
  bool _isload = false;
  bool _isloading = false;
  bool _showsubDistrict = false;
  bool _showvillage = false;
  bool _showsubVillage = false;
  List<ContentDatabaseModel> headers = [];
  List<QuestionAnswerDbModel> questions = [];
  List freeTextQuestion = [];
  List freeTextValue = [];
  List dropdown = [];
  List dropdownAnswer = [];
  List dropdownSplit = [];
  List dropdownQuestion = [];
  List questionIdFreeText = [];
  List questionIdChoice = [];
  List headerAnswer = [];

  List selectVal = [];
  final Map<String, dynamic> answersFreeTextMap = {};
  final Map<String, dynamic> answersChoiceMap = {};

  String municipalityValue = '';
  String subDistrictValue = '';
  String villageValue = '';
  String subVillageValue = '';

  read() async {
    setState(() {
      _isloading = true;
    });
    headers = await FormTableDatabase.instance.readContent(widget.code);
    for (int i = 0; i < headers.length; i++) {
      print("form type : " + headers[i].formType.toString());
      print("form key : " + headers[i].key.toString());
      print("form value : " + headers[i].value.toString());
    }
    _nameController.text = headers[2].value.toString();
    _interviewerController.text = headers[8].value.toString();
    _headVillageController.text = headers[9].value.toString();

    questions =
        await FormTableDatabase.instance.readQuestionAnswer(widget.code);
    for (int i = 0; i < questions.length; i++) {
      if (questions[i].input_type == "FreeText") continue;
      questionIdChoice.add(questions[i].id);
      print("dropdowns: " + questions[i].dropdown.toString());
      dropdown.add(questions[i].dropdown);
      dropdownAnswer.add(questions[i].answer);
      dropdownQuestion.add(questions[i].question.toString());
    }

    dropdownAnswer.forEach((element) {
      print("DROPDOWN ANSWER: " + element);
    });

    for (int i = 0; i < questions.length; i++) {
      print("QUESTION FREETEXT: " + questions[i].question.toString());
      if (questions[i].input_type == "Choice") continue;
      questionIdFreeText.add(questions[i].id);
      freeTextQuestion.add(questions[i].question.toString());
      freeTextValue.add(questions[i].answer.toString());
      answersFreeTextMap[questions[i].question.toString()] = freeTextValue[i];
    }

    MunicipalityModel _resMunicipality = await ApiService().municipalityAPI();
    setState(() {
      municipalityList = _resMunicipality.data;
      _isloading = false;
    });
  }

  // String _randomCode() {
  //   Random random = Random();
  //   int randomNumber = random.nextInt(900) + 100;
  //   String date = DateFormat('ddMMyyyy').format(DateTime.now());
  //
  //   String result = '${headers[0].formType}-$date-$randomNumber';
  //   return result;
  // }

  Future update() async {
    headerAnswer.add(headers[0].value);
    headerAnswer.add(headers[1].value);
    headerAnswer.add(_nameController.text);
    headerAnswer.add(_selectDate);
    municipalityValue.isEmpty ? headerAnswer.add(headers[4].value.toString()) : headerAnswer.add(municipalityValue);
    subDistrictValue.isEmpty ? headerAnswer.add(headers[5].value.toString()) : headerAnswer.add(subDistrictValue);
    villageValue.isEmpty ? headerAnswer.add(headers[6].value.toString()) : headerAnswer.add(villageValue);
    subVillageValue.isEmpty ? headerAnswer.add(headers[7].value.toString()) : headerAnswer.add(subVillageValue);
    headerAnswer.add(_interviewerController.text);
    headerAnswer.add(_headVillageController.text);
    var headerUpdate;
    headerAnswer.forEach((element) {
      print("HEADER ANSWER: " + element);
    });
    for (int i = 0; i < headers.length; i++) {
      await FormTableDatabase.instance
          .updateContent(headerAnswer[i], headers[i].id!);
    }

    int indexFreeText = 0;
    answersFreeTextMap.forEach((key, value) {
      FormTableDatabase.instance
          .updateQuestionAnswer(value, questionIdFreeText[indexFreeText]);
      indexFreeText++;
    });

    int indexChoice = 0;
    answersChoiceMap.forEach((key, value) {
      FormTableDatabase.instance
          .updateQuestionAnswer(value, questionIdChoice[indexChoice]);
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
          appBar: AppBar(),
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
        height: 60.h,
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
          padding: EdgeInsets.only(left: 12),
          child: Text(
              headers[4].key.toString() + " : " + headers[4].value.toString(),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Center(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                height: 50.h,
                width: 400.w,
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5)),
                child: DropdownButton<MunicipalityData>(
                  isExpanded: true,
                  value: dropdownMunicipality,
                  icon: Icon(Icons.arrow_drop_down),
                  onChanged: (MunicipalityData? newValue) async {
                    if (dropdownMunicipality != null) {
                      setState(() {
                        _isload = true;
                      });
                      municipalityValue = newValue!.name;
                      SubdisctrictByMuniModel _resSubdistrict =
                          await ApiService().subdisctrictByMuniAPI(
                              id: newValue.id.toString(),
                              code: newValue.code,
                              name: newValue.name,
                              desc: newValue.description);
                      setState(() {
                        dropdownsubDistrict = null;
                        dropdownVillage = null;
                        dropdownsubVillage = null;
                        dropdownMunicipality = newValue;
                        subDistrictList = _resSubdistrict.data;
                        _isload = false;
                      });
                    } else {
                      setState(() {
                        _isload = true;
                      });
                      municipalityValue = newValue!.name;
                      SubdisctrictByMuniModel _resSubdistrict =
                          await ApiService().subdisctrictByMuniAPI(
                              id: newValue.id.toString(),
                              code: newValue.code,
                              name: newValue.name,
                              desc: newValue.description);
                      setState(() {
                        dropdownMunicipality = newValue;
                        subDistrictList = _resSubdistrict.data;
                        _isload = false;
                      });
                    }
                  },
                  isDense: true,
                  underline: SizedBox.shrink(),
                  items: municipalityList.map((MunicipalityData item) {
                    return DropdownMenuItem<MunicipalityData>(
                      child: Text(
                        item.name.toString(),
                      ),
                      value: item,
                    );
                  }).toList(),
                )),
          ),
        ),
        _buildDropdownsubDistrict()
      ],
    );
  }

  _buildDropdownsubDistrict() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(
              headers[5].key.toString() + " : " + headers[5].value.toString(),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Center(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                height: 50.h,
                width: 400.w,
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5)),
                child: DropdownButton<SubdisctrictByMuniData>(
                  isExpanded: true,
                  value: dropdownsubDistrict,
                  icon: Icon(Icons.arrow_drop_down),
                  onChanged: (SubdisctrictByMuniData? newValue) async {
                    if (dropdownsubDistrict != null) {
                      setState(() {
                        _isload = true;
                      });
                      subDistrictValue = newValue!.name;
                      VillageBySubModel _resVillage = await ApiService()
                          .villageBySubAPI(
                              id: newValue.id,
                              code: newValue.code,
                              desc: newValue.description,
                              name: newValue.name);
                      setState(() {
                        dropdownVillage = null;
                        dropdownsubVillage = null;
                        dropdownsubDistrict = newValue;
                        villageList = _resVillage.data;
                        _isload = false;
                      });
                    } else {
                      setState(() {
                        _isload = true;
                      });
                      subDistrictValue = newValue!.name;
                      VillageBySubModel _resVillage = await ApiService()
                          .villageBySubAPI(
                              id: newValue.id,
                              code: newValue.code,
                              desc: newValue.description,
                              name: newValue.name);
                      setState(() {
                        dropdownsubDistrict = newValue;
                        villageList = _resVillage.data;
                        _isload = false;
                      });
                    }
                  },
                  isDense: true,
                  underline: SizedBox.shrink(),
                  items: subDistrictList.map((SubdisctrictByMuniData item) {
                    return DropdownMenuItem<SubdisctrictByMuniData>(
                      child: Text(
                        item.name.toString(),
                      ),
                      value: item,
                    );
                  }).toList(),
                )),
          ),
        ),
        _buildDropdownVillage()
      ],
    );
  }

  _buildDropdownVillage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(
              headers[6].key.toString() + " : " + headers[6].value.toString(),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Center(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                height: 50.h,
                width: 400.w,
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5)),
                child: DropdownButton<VillageBySubData>(
                  isExpanded: true,
                  value: dropdownVillage,
                  icon: Icon(Icons.arrow_drop_down),
                  onChanged: (VillageBySubData? newValue) async {
                    if (dropdownVillage != null) {
                      setState(() {
                        _isload = true;
                      });
                      villageValue = newValue!.name;
                      SubvillageByVillModel _resSubvillage = await ApiService()
                          .subVillageByVillAPI(
                              id: newValue.id,
                              code: newValue.code,
                              name: newValue.name,
                              desc: newValue.description);
                      setState(() {
                        dropdownsubVillage = null;
                        dropdownVillage = newValue;
                        subVillageList = _resSubvillage.data;
                        _isload = false;
                      });
                    } else {
                      setState(() {
                        _isload = true;
                      });
                      villageValue = newValue!.name;
                      SubvillageByVillModel _resSubvillage = await ApiService()
                          .subVillageByVillAPI(
                              id: newValue.id,
                              code: newValue.code,
                              name: newValue.name,
                              desc: newValue.description);
                      setState(() {
                        dropdownVillage = newValue;
                        subVillageList = _resSubvillage.data;
                        _isload = false;
                      });
                    }
                  },
                  isDense: true,
                  underline: SizedBox.shrink(),
                  items: villageList.map((VillageBySubData item) {
                    return DropdownMenuItem<VillageBySubData>(
                      child: Text(
                        item.name.toString(),
                      ),
                      value: item,
                    );
                  }).toList(),
                )),
          ),
        ),
        _buildDropdownsubVillage()
      ],
    );
  }

  _buildDropdownsubVillage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(
              headers[7].key.toString() + " : " + headers[7].value.toString(),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Center(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                height: 50.h,
                width: 400.w,
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5)),
                child: DropdownButton<SubvillageByVillageData>(
                  isExpanded: true,
                  value: dropdownsubVillage,
                  icon: Icon(Icons.arrow_drop_down),
                  onChanged: (SubvillageByVillageData? newValue) {
                    setState(() {
                      subVillageValue = newValue!.name;
                      dropdownsubVillage = newValue;
                    });
                  },
                  isDense: true,
                  underline: SizedBox.shrink(),
                  items: subVillageList.map((SubvillageByVillageData item) {
                    return DropdownMenuItem<SubvillageByVillageData>(
                      child: Text(
                        item.name.toString(),
                      ),
                      value: item,
                    );
                  }).toList(),
                )),
          ),
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
          padding: EdgeInsets.only(top: 12),
          child: Center(
              child: Text(headers[0].value.toString(),
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
        ),
        SizedBox(height: 30.h),
        Center(
            child: Text(headers[1].value.toString(),
                style: TextStyle(fontSize: 15), textAlign: TextAlign.center)),
        SizedBox(height: 30.h),
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(headers[2].key.toString() + " :",
              style: TextStyle(fontSize: 15)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: CustomTextField(
            isEnable: true,
            isreadOnly: false,
            controller: _nameController,
            inputType: TextInputType.text,
            validator: (value) => SharedCode().emptyValidator(value),
          ),
        ),
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(
              headers[3].key.toString() + " : " + headers[3].value.toString(),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: _buildDatePickerField(),
        ),
        SizedBox(height: 20.h),
        _buildDropdownMunicipality(),
        Padding(
          padding: EdgeInsets.only(left: 12, top: 10),
          child: Text(headers[8].key.toString() + " :",
              style: TextStyle(fontSize: 15)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: CustomTextField(
            isEnable: true,
            isreadOnly: false,
            controller: _interviewerController,
            inputType: TextInputType.text,
            validator: (value) => SharedCode().emptyValidator(value),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 12, top: 10),
          child: Text(headers[9].key.toString() + " :",
              style: TextStyle(fontSize: 15)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: CustomTextField(
            isEnable: true,
            isreadOnly: false,
            controller: _headVillageController,
            inputType: TextInputType.text,
            validator: (value) => SharedCode().emptyValidator(value),
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
              padding: EdgeInsets.only(left: 12, top: 10),
              child: Text(dropdownQuestion[index].toString() + " :",
                  style: TextStyle(fontSize: 15)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Center(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    height: 50.h,
                    width: 400.w,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(5)),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: dropdownAnswer[index],
                      icon: Icon(Icons.arrow_drop_down),
                      onChanged: (value) {
                        setState(() {
                          dropdownAnswer[index] = value!;
                          answersChoiceMap[dropdownQuestion[index].toString()] =
                              dropdownAnswer[index];
                        });
                      },
                      isDense: true,
                      underline: SizedBox.shrink(),
                      items: dropdown[index]
                          .split("Îµ")
                          .map<DropdownMenuItem<String>>((e) {
                        return DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        );
                      }).toList(),
                    )),
              ),
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
              padding: EdgeInsets.only(left: 12, top: 10),
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
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: TextFormField(
                    initialValue: freeTextValue[index],
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
      padding: EdgeInsets.only(top: 15, bottom: 15),
      child: Center(
        child: Container(
          height: 50.h,
          width: 250.w,
          child: ElevatedButton(
              onPressed: () {
                showAlertDialogSave(context);
              },
              child: Text("Atualizar",
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
        update();
        if (!mounted) return;
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Aviso"),
      content: Text("Você quer salvar a resposta?"),
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
