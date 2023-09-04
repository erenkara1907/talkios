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
  String englandFlag = '$asset' 'england_flag.svg';
  String germanyFlag = '$asset' 'germany_flag.svg';
  String portugalFlag = '$asset' 'portugal_flag.svg';
  String spainFlag = '$asset' 'spain_flag.svg';
  String turkeyFlag = '$asset' 'turkey_flag.svg';
  String franceFlag = '$asset' 'france_flag.svg';
  String chinaFlag = '$asset' 'china_flag.svg';
  String saudiFlag = '$asset' 'saudi_flag.svg';
  String russianFlag = '$asset' 'russian_flag.svg';
}
