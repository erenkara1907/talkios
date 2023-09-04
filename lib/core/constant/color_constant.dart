import 'package:flutter/material.dart';

class ColorConstant {
  static ColorConstant? _instance;
  static ColorConstant get instance {
    _instance ??= ColorConstant._init();
    return _instance!;
  }

  ColorConstant._init();

  Color background = const Color.fromRGBO(255, 255, 255, 1);

  Color softPink = const Color.fromRGBO(245, 189, 251, 1);
  Color softCyan = const Color.fromRGBO(164, 237, 236, 1);
  Color softYellow = const Color.fromARGB(251, 233, 146, 1);
  Color softLightGreen = const Color.fromRGBO(166, 239, 185, 1);
  Color softPurple = const Color.fromRGBO(159, 121, 218, 1);
  Color softBlue = const Color.fromRGBO(153, 187, 246, 1);
  Color softOrange = const Color.fromRGBO(245, 184, 133, 1);
  Color softGreen = const Color.fromRGBO(142, 191, 161, 1);

  Color pink = const Color.fromRGBO(239, 145, 249, 1);
  Color cyan = const Color.fromRGBO(103, 225, 224, 1);
  Color yellow = const Color.fromRGBO(249, 219, 74, 1);
  Color lightGreen = const Color.fromRGBO(106, 229, 139, 1);
  Color purple = const Color.fromRGBO(95, 31, 193, 1);
  Color blue = const Color.fromRGBO(85, 141, 240, 1);
  Color orange = const Color.fromRGBO(239, 137, 51, 1);
  Color green = const Color.fromRGBO(66, 149, 99, 1);

  Color dark100 = const Color.fromRGBO(5, 5, 8, 1);
  Color dark90 = const Color.fromRGBO(5, 5, 8, 0.9);
  Color dark80 = const Color.fromRGBO(5, 5, 8, 0.8);
  Color dark70 = const Color.fromRGBO(5, 5, 8, 0.7);
  Color dark60 = const Color.fromRGBO(5, 5, 8, 0.6);
  Color dark50 = const Color.fromRGBO(5, 5, 8, 0.5);
  Color dark40 = const Color.fromRGBO(5, 5, 8, 0.4);
  Color dark30 = const Color.fromRGBO(5, 5, 8, 0.3);
  Color dark20 = const Color.fromRGBO(5, 5, 8, 0.2);
  Color dark10 = const Color.fromRGBO(5, 5, 8, 0.1);
}
