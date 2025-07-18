import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yardify/widgets/hex.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.grey[900],
  primaryColorLight: Colors.white,
  hintColor: Colors.tealAccent,
  shadowColor: Colors.grey.shade800,
  scaffoldBackgroundColor: hexToColor("#1F1F1F"),
  primaryTextTheme: TextTheme(labelMedium: TextStyle(color: Colors.white)),
);

ThemeData lightTheme = ThemeData(
  primaryTextTheme: TextTheme(labelMedium: TextStyle(color: Colors.black)),
  primaryColorLight: Colors.black,
  primaryColor: Colors.white,
  shadowColor: Colors.grey.shade300,
  textTheme: GoogleFonts.robotoTextTheme(ThemeData.light().textTheme),
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
  // scaffoldBackgroundColor: hexToColor("#F5F5F5"),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.white,
    centerTitle: true,
    titleTextStyle: TextStyle(fontSize: 19, color: Colors.black),
  ),
);
