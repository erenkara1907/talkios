// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talkios/core/cache/cache_manager.dart';
import 'package:talkios/core/enum/preference_keys.dart';

import '../../../core/constant/icon_constant.dart';
import '../model/menu_card_model.dart';

class BottomMenuViewModel extends ChangeNotifier {
  bool _isOpenTasks = false;
  bool get isOpenTasks => _isOpenTasks;

  bool _isOpenClue = false;
  bool get isOpenClue => _isOpenClue;

  bool _isOpenTranslate = false;
  bool get isOpenTranslate => _isOpenTranslate;

  bool _isCopied = false;
  bool get isCopied => _isCopied;

  TextEditingController nativeController = TextEditingController();
  TextEditingController translateController = TextEditingController();

  FocusNode nativeFocusNode = FocusNode();

  void deFocus() {
    nativeFocusNode.unfocus();
  }

  set isCopied(bool value) {
    _isCopied = value;
    notifyListeners();
  }

  void clipToClipboard(String text) {
    if (!_isCopied && text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: text));
      isCopied = true;
    } else {
      isCopied = false;
    }
  }

  // Model
  List<MenuCardModel> menuCards = [
    MenuCardModel(
      id: 1,
      text: "Tasks",
      svgIcon: IconConstant.instance.task,
    ),
    MenuCardModel(
      id: 3,
      text: "Clue",
      svgIcon: IconConstant.instance.clue,
    ),
    MenuCardModel(
      id: 4,
      text: "Translate",
      svgIcon: IconConstant.instance.translate,
    ),
  ];

  String getLanguageIcon() {
    String? _language =
        CacheManager().getString(PreferencesKeys.LANGUAGE.toString());

    switch (_language) {
      case "Turkish":
        return IconConstant.instance.turkeyFlag;
      case "Spanish":
        return IconConstant.instance.spainFlag;
      case "German":
        return IconConstant.instance.germanyFlag;
      case "Portuguese":
        return IconConstant.instance.portugalFlag;
      case "Russian":
        return IconConstant.instance.russianFlag;
      case "French":
        return IconConstant.instance.franceFlag;
      case "Chinese":
        return IconConstant.instance.chinaFlag;
      case "Arabic":
        return IconConstant.instance.saudiFlag;
      default:
        return IconConstant.instance.turkeyFlag;
    }
  }

  set isOpenTranslate(bool value) {
    _isOpenTranslate = value;
    notifyListeners();
  }

  void openTask(bool value) {
    _isOpenTasks = value;
    notifyListeners();
  }

  void openClue(bool value) {
    _isOpenClue = value;
    notifyListeners();
  }
}
