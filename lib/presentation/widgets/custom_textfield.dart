import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final bool? readOnly ;
  final void Function()? onTap;
  const CustomTextField(
      {super.key,
      this.controller,
      this.readOnly,
      required this.hintText,
      this.onTap,
      this.keyboardType,
      this.inputFormatters});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return '$hintText can\'t be empty';
          }
          return null;
        },
        inputFormatters: inputFormatters,
        onTap: onTap,
        readOnly: readOnly ?? false,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
        ));
  }
}
