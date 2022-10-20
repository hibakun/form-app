import 'package:flutter/material.dart';
import 'package:form_app/model/database/content.dart';
import 'package:form_app/ui/dashboard/item/list_form.dart';

import '../../../database/FormDb.dart';

class AddFormPage extends StatefulWidget {
  const AddFormPage({Key? key}) : super(key: key);

  @override
  State<AddFormPage> createState() => _AddFormPageState();
}

class _AddFormPageState extends State<AddFormPage> {
  List<ContentDatabaseModel> contentList = [];
  bool isLoading = false;

  Future read() async {
    setState(() {
      isLoading = true;
    });
    contentList = await FormTableDatabase.instance.contentReadAll();
    if (contentList.isEmpty){
      setState(() {
        isLoading = true;
      });
    } else {
      setState(() {
        isLoading = true;
      });
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(contentList[index].code.toString()),
                  subtitle: Text(contentList[index].formType.toString()),
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
