import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Function(String) validator;

  const AppTextFormField(
      {Key key, @required this.hintText, this.controller, this.validator});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (val) => validator(val),
      controller: controller,
      decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.only(left: 20),
          filled: true,
          border: InputBorder.none,
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.blue))),
    );
  }
}
