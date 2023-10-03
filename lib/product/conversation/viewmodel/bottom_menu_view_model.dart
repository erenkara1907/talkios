import 'package:flutter/material.dart';

import '../../../core/constant/icon_constant.dart';
import '../model/menu_card_model.dart';

class BottomMenuViewModel extends ChangeNotifier {
  bool _isOpenTasks = false;
  bool get isOpenTasks => _isOpenTasks;

  bool _isOpenClue = false;
  bool get isOpenClue => _isOpenClue;

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
  ];

  void openTask(bool value) {
    _isOpenTasks = value;
    notifyListeners();
  }

  void openClue(bool value) {
    _isOpenClue = value;
    notifyListeners();
  }
}
