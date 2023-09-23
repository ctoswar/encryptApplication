import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  const MyTextField(
      {super.key,
      required this.controller,
      required this.hint,
      required this.obscureText,
      required Color background});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: Colors.black),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        fillColor: const Color(0xFFE2EBF0),
        filled: true,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black),
      ),
    );
  }
}
