import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_app/common/shared_code.dart';
import 'package:form_app/common/string_extension.dart';
import 'package:form_app/database/FormDb.dart';
import 'package:form_app/model/database/header.dart';
import 'package:form_app/model/database/question.dart';
import 'package:form_app/model/municipality_model.dart';
import 'package:form_app/model/subdisctrict_by_muni_model.dart';
import 'package:form_app/model/subdisctrict_model.dart';
import 'package:form_app/model/subvillage_by_vill_model.dart';
import 'package:form_app/model/subvillage_model.dart';
import 'package:form_app/model/village_by_sub_model.dart';
import 'package:form_app/service/api_service.dart';
import 'package:form_app/ui/widget/custom_text_field.dart';
import 'package:intl/intl.dart';

class ReadFormPage extends StatefulWidget {
  final String formType;

  const ReadFormPage({Key? key, required this.formType}) : super(key: key);

  @override
  State<ReadFormPage> createState() => _ReadFormPageState();
}

class _ReadFormPageState extends State<ReadFormPage> {
  final _nameController = TextEditingController();
  final _naranController = TextEditingController();
  final _interviewerController = TextEditingController();
  final _headVillageController = TextEditingController();
  bool _isloading = false;
  List<HeaderDatabaseModel> headers = [];
  List<QuestionDbModel> questions = [];

  read() async {
    setState(() {
      _isloading = true;
    });
    headers = await FormTableDatabase.instance.readHeader(widget.formType);
    for (int i = 0; i < headers.length; i++) {
      print("form type : " + headers[i].formType.toString());
      print("form key : " + headers[i].key.toString());
      print("form value : " + headers[i].value.toString());
    }
    questions = await FormTableDatabase.instance.readQuestion(widget.formType);
    for (int i = 0; i < questions.length; i++) {
      print("form question : " + questions[i].question.toString());
    }
    setState(() {
      _isloading = false;
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
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 50.h,
            title: Text("Formul??rio " + widget.formType + " de visualiza????o",
                style: TextStyle(fontSize: 20)),
          ),
          body: _isloading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _headerForm(),
                        _bodyForm(),
                      ],
                    ),
                  ),
                )),
    );
  }

  Widget _buildDatePickerField() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
      height: 40.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 25),
            child: Text("2005-10-10", style: TextStyle(fontSize: 14)),
          ),
          SizedBox(
            width: 10.w,
          ),
          Icon(Icons.arrow_drop_down)
        ],
      ),
    );
  }

  _buildDropdownMunicipality() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(headers[3].key.toString().capitalize() + " :",
              style: TextStyle(fontSize: 15)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5)),
                child: DropdownButton(
                  isExpanded: true,
                  value: "",
                  icon: Icon(Icons.arrow_drop_down),
                  onChanged: null,
                  isDense: true,
                  underline: SizedBox.shrink(),
                  items: [],
                )),
          ),
        ),
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
          child: Text(headers[4].key.toString().capitalize().replaceAll("_", " ") + " :",
              style: TextStyle(fontSize: 15)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5)),
                child: DropdownButton(
                  isExpanded: true,
                  value: "",
                  icon: Icon(Icons.arrow_drop_down),
                  onChanged: null,
                  isDense: true,
                  underline: SizedBox.shrink(),
                  items: [],
                )),
          ),
        ),
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
          child: Text(headers[5].key.toString().capitalize() + " :",
              style: TextStyle(fontSize: 15)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5)),
                child: DropdownButton(
                  isExpanded: true,
                  value: "",
                  icon: Icon(Icons.arrow_drop_down),
                  onChanged: null,
                  isDense: true,
                  underline: SizedBox.shrink(),
                  items: [],
                )),
          ),
        ),
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
          child: Text(headers[6].key.toString().capitalize() + " :",
              style: TextStyle(fontSize: 15)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5)),
                child: DropdownButton(
                  isExpanded: true,
                  value: "",
                  icon: Icon(Icons.arrow_drop_down),
                  onChanged: null,
                  isDense: true,
                  underline: SizedBox.shrink(),
                  items: [],
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
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          child: Center(
              child: Text(headers[0].value.toString(),
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
        ),
        Center(
            child: Text(headers[1].value.toString(),
                style: TextStyle(fontSize: 15), textAlign: TextAlign.center)),
        SizedBox(height: 30.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(headers[2].key.toString().capitalize().replaceAll("_", " ") + " :",
              style: TextStyle(fontSize: 15)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: _buildDatePickerField(),
        ),
        _buildDropdownMunicipality(),
        _buildDropdownsubDistrict(),
        _buildDropdownVillage(),
        _buildDropdownsubVillage(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(headers[7].key.toString().capitalize().replaceAll("_", " ") + " :",
              style: TextStyle(fontSize: 15)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: CustomTextField(
            isEnable: false,
            isreadOnly: true,
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

  _bodyForm() {
    return Column(
      children: List.generate(questions.length, (index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(questions[index].question.toString() + " :",
                  style: TextStyle(fontSize: 15)),
            ),
            questions[index].input_type == "FreeText"
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: CustomTextField(
                      isEnable: false,
                      isreadOnly: true,
                      controller: _naranController,
                      inputType: TextInputType.text,
                      validator: (value) => SharedCode().emptyValidator(value),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  )
                : Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(5)),
                          child: DropdownButton(
                            isExpanded: true,
                            value: "",
                            icon: Icon(Icons.arrow_drop_down),
                            onChanged: null,
                            isDense: true,
                            underline: SizedBox.shrink(),
                            items: [],
                          )),
                    ),
                  ),
          ],
        );
      }),
    );
  }
}
