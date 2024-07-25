import 'package:flutter/material.dart';

Widget textBox({required String labelText, required TextEditingController controller}) {
  return TextFormField(
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      labelText: labelText
    ),
    controller: controller,
  );
}