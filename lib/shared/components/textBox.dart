import 'package:flutter/material.dart';

Widget textBox({required String text, required TextEditingController controller}) {
  return TextFormField(
    decoration: InputDecoration(
      border: const OutlineInputBorder(),
      labelText: text
    ),
    controller: controller,
  );
}