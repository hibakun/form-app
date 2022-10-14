import 'package:flutter/material.dart';
import 'package:form_app/common/validator.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType inputType;
  final String? Function(String?)? validator;
  final bool isPassword;

  const CustomTextField(
      {Key? key,
      required this.controller,
      this.inputType = TextInputType.text,
      this.validator,
      this.isPassword = false})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    dynamic validator = widget.validator;
    validator ??= Validator().emptyValidator;

    return TextFormField(
      style: Theme.of(context).textTheme.bodyText1,
      controller: widget.controller,
      keyboardType: widget.inputType,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: widget.isPassword,
      autocorrect: !widget.isPassword,
      enableSuggestions: !widget.isPassword,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
