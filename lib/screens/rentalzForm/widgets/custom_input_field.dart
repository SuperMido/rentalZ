import 'package:flutter/material.dart';

import '../../../constants.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final IconData prefixIcon;
  final bool obscureText;
  final String? Function(String?) validation;
  final String? Function(String?) onChanged;

  const CustomInputField({
    required this.label,
    required this.prefixIcon,
    required this.validation,
    this.obscureText = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(kPaddingM),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black.withOpacity(0.12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black.withOpacity(0.12)),
        ),
        hintText: label,
        hintStyle: TextStyle(
          color: kBlack.withOpacity(0.5),
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: kBlack.withOpacity(0.5),
        ),
      ),
      validator: validation,
      onChanged: onChanged,
      obscureText: obscureText,
      inputFormatters: [],
    );
  }
}
