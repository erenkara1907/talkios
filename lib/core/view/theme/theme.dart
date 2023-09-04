import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: const Color.fromRGBO(255, 255, 255, 1),
  primaryColorLight: const Color.fromRGBO(255, 255, 254, 1),
  primaryColorDark: const Color.fromRGBO(22, 26, 13, 1),
  cardColor: const Color.fromRGBO(91, 95, 82, 1),
  canvasColor: Colors.transparent,
  shadowColor: const Color.fromRGBO(91, 95, 82, 1),
  hintColor: const Color.fromRGBO(224, 228, 212, 1),
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 22.0, fontFamily: "Poppins"),
    displayMedium: TextStyle(fontSize: 18.0, fontFamily: "Poppins"),
    displaySmall: TextStyle(fontSize: 16.0, fontFamily: "Poppins"),
    headlineMedium: TextStyle(fontSize: 14.0, fontFamily: "Poppins"),
    headlineSmall: TextStyle(fontSize: 12.0, fontFamily: "Poppins"),
    titleLarge: TextStyle(fontSize: 12.0, fontFamily: "Poppins"),
    bodySmall: TextStyle(fontSize: 10.0, fontFamily: "Poppins"),
    titleMedium: TextStyle(fontSize: 24.0, fontFamily: "Poppins"),
  ),
);
