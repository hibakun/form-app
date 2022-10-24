import 'package:flutter/material.dart';

class UploadDataPage extends StatefulWidget {
  const UploadDataPage({Key? key}) : super(key: key);

  @override
  State<UploadDataPage> createState() => _UploadDataPageState();
}

class _UploadDataPageState extends State<UploadDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Página inicial (Enviar formulário)"),
      ),
      body: Center(
        child: Text('Upload Data'),
      ),
    );
  }
}
