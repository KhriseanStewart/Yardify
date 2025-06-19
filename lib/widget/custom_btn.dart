import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final String btntext;
  final VoidCallback? onpress;
  final Color? btnColor;
  final Icon icon;
  const CustomBtn({
    super.key,
    required this.btntext,
    required this.onpress,
    required this.icon,
    this.btnColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: icon,
      onPressed: onpress,
      label: Text(btntext),
      style: TextButton.styleFrom(backgroundColor: btnColor),
    );
  }
}
