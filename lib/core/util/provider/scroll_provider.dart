// ignore_for_file: unused_field, prefer_final_fields

import 'package:flutter/material.dart';

class ScrollProvider extends ChangeNotifier {
  Color _color = Colors.blue;
  Color get color => _color;

  void changeColor(Color newColor) {
    _color = newColor;
    notifyListeners();
  }

  void resetColor() {
    _color = Colors.blue;
    notifyListeners();
  }
}
