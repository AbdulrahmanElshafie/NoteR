import 'package:flutter/material.dart';

Widget btn({required String text, required VoidCallback onPressed}) {
  return Container(
    width: 200,
    decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [
              Colors.blueAccent,
              Colors.blue,
              Colors.green,
              Colors.greenAccent
            ]
        ),
        borderRadius: BorderRadius.circular(10)
    ),
    child: TextButton(
        onPressed: onPressed,
        child: Text(
            text,
          style: const TextStyle(
            color: Colors.white
          ),
        ),
    ),
  );
}