import 'package:flutter/material.dart';

class FillFormPage extends StatefulWidget {
  const FillFormPage({Key? key}) : super(key: key);

  @override
  State<FillFormPage> createState() => _FillFormPageState();
}

class _FillFormPageState extends State<FillFormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Fill Form'),
      ),
    );
  }
}
