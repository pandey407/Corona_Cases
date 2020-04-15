import 'package:flutter/material.dart';

Color kBoxDarkColor = Color(0xFF1C1B32);
Color kBoxLightColor = Colors.white;
Color myBoxLightColor = Colors.white60;
Color myBoxDarkColor = Color(0xFF202040);
BorderRadius kBoxesRadius = BorderRadius.circular(20);
String allCasesAPI = 'https://corona.lmao.ninja/all';
String affectedCountriesAPI = 'https://corona.lmao.ninja/countries';
String nepalCasesAPI = 'https://corona.lmao.ninja/countries/Nepal';
ThemeData kDarkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.black,
  scaffoldBackgroundColor: Colors.black54,
);
ThemeData kLightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.grey[100],
  scaffoldBackgroundColor: Colors.grey[300],
);
