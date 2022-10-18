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
  bool _isload = false;
  List<HeaderDatabaseModel> data = [];

  read() async {
    setState(() {
      _isload = true;
    });
    data = await FormTableDatabase.instance.readHeader(widget.formType);
    for (int i = 0; i < data.length; i++) {
      print("form type : " + data[i].formType.toString());
      print("form key : " + data[i].key.toString());
      print("form value : " + data[i].value.toString());
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
            : ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 3,
                    shadowColor: Colors.black,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Text(data[index].key.toString()),
                          Text(data[index].value.toString()),
                        ],
                      ),
                    ),
                  );
                },
              ));
  }
}
