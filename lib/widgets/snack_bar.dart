import 'package:flutter/material.dart';

void displaySnackBar(
  BuildContext context,
  String message, {
  Color backgroundColor = Colors.white,
  Color textColor = Colors.red,
  Duration duration = const Duration(seconds: 5),
  SnackBarAction? action,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: Text(
          message,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      duration: duration,
    ),
  );
}
