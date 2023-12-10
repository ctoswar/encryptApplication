import 'package:flutter/material.dart';

class MyTextField_chat extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  const MyTextField_chat(
      {super.key,
      required this.controller,
      required this.hint,
      required this.obscureText,
      required Color background,
      required MaterialColor backgroundColor});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        fillColor: Colors.grey[250],
        filled: true,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black),
      ),
    );
  }
}
