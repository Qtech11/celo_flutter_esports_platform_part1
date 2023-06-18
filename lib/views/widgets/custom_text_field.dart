import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    this.hintText,
    this.keyboardType,
    required this.controller,
    this.iconButton,
    this.readOnly = false,
  }) : super(key: key);

  final String? hintText;
  final TextInputType? keyboardType;
  final TextEditingController controller;
  final IconButton? iconButton;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      decoration: InputDecoration(
        suffixIcon: iconButton,
        hintText: hintText,
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blueGrey,
            width: 1,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(3.0),
          ),
        ),
      ),
    );
  }
}
