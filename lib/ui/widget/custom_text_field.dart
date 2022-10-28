import 'package:flutter/material.dart';
import 'package:form_app/common/shared_code.dart';

class CustomTextField extends StatefulWidget {
  final bool isEnable;
  final bool isreadOnly;
  final TextEditingController controller;
  final TextInputType inputType;
  final String? Function(String?)? validator;
  final bool isPassword;
  final InputDecoration decoration;

  const CustomTextField(
      {Key? key,
      required this.controller,
      this.inputType = TextInputType.text,
      this.validator,
      required this.decoration,
      this.isPassword = false,
      required this.isEnable,
      required this.isreadOnly})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    dynamic validator = widget.validator;
    validator ??= SharedCode().emptyValidator;

    return TextFormField(
      enabled: widget.isEnable,
      readOnly: widget.isreadOnly,
      style: Theme.of(context).textTheme.bodyText1,
      controller: widget.controller,
      keyboardType: widget.inputType,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: widget.isPassword,
      autocorrect: true,
      enableSuggestions: true,
      decoration: widget.decoration,
    );
  }
}
