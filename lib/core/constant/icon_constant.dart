import 'package:flutter/material.dart';

String asset = 'assets/icons/icon_';

class IconConstant {
  static IconConstant? _instance;
  static IconConstant get instance {
    _instance ??= IconConstant._init();
    return _instance!;
  }

  IconConstant._init();

  IconData arrowBack = Icons.arrow_back_ios;
  IconData arrowForward = Icons.arrow_forward_ios;

  // Svg
  String mission = '$asset' 'mission.svg';
  String star = '$asset' 'star.svg';
  String accountSettings = '$asset' 'account_settings.svg';
  String award = '$asset' 'award.svg';
  String language = '$asset' 'language.svg';
  String personalInformation = '$asset' 'personal_information.svg';
  String statistics = '$asset' 'statistics.svg';
  String terms = '$asset' 'terms.svg';
  String writeUs = '$asset' 'write_us.svg';
  String flag = '$asset' 'flag.svg';
  String card = '$asset' 'card.svg';
  String microphone = '$asset' 'microphone.svg';
  String sound = '$asset' 'sound.svg';
  String send = '$asset' 'send.svg';
  String close = '$asset' 'close.svg';
  String task = '$asset' 'task.svg';
  String translate = '$asset' 'translate.svg';
  String clue = '$asset' 'clue.svg';
  String lock = '$asset' 'lock.svg';
  String englandFlag = '$asset' 'england_flag.svg';
  String germanyFlag = '$asset' 'germany_flag.svg';
  String portugalFlag = '$asset' 'portugal_flag.svg';
  String spainFlag = '$asset' 'spain_flag.svg';
  String turkeyFlag = '$asset' 'turkey_flag.svg';
  String franceFlag = '$asset' 'france_flag.svg';
  String chinaFlag = '$asset' 'china_flag.svg';
  String saudiFlag = '$asset' 'saudi_flag.svg';
  String russianFlag = '$asset' 'russian_flag.svg';
  String lockScenario = '$asset' 'lock_scenario.svg';
  String kite = '$asset' 'kite.svg';
  String speak = '$asset' 'speak.svg';
  String tick = '$asset' 'tick.svg';
  String tip = '$asset' 'tip.svg';
  String translateDetail = '$asset' 'translate_detail.svg';
  String taskDetail = '$asset' 'task_detail.svg';
  String fluentPerson = '$asset' 'fluent_person.svg';
  String soundVocabulary = '$asset' 'sound_vocabulary.svg';
  String lockHome = '$asset' 'lock_home.svg';
  String completed = '$asset' 'completed.svg';
  String openScenario = '$asset' 'open_scenario.svg';
  String voice = '$asset' 'voice.svg';

  // Png
  String premium = '$asset' 'premium.png';
  String appIcon = 'assets/icons/app_icon.png';
}
