import 'package:flutter/material.dart';

class ChatToolsProvider extends ChangeNotifier {
  bool _isTranslate = false;
  bool get isTranslate => _isTranslate;

  bool _isTip = false;
  bool get isTip => _isTip;

  bool _isPronunciation = false;
  bool get isPronunciation => _isPronunciation;

  int _messageIndex = -1;
  int get messageIndex => _messageIndex;

  set messageIndex(int value) {
    _messageIndex = value;
    notifyListeners();
  }

  set isTranslate(bool value) {
    _isTranslate = value;
    notifyListeners();
  }

  set isTip(bool value) {
    _isTip = value;
    notifyListeners();
  }

  set isPronunciation(value) {
    _isPronunciation = value;
    notifyListeners();
  }
}
