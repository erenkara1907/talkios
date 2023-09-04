import 'package:flutter/material.dart';
import 'package:talkios/core/cache/cache_manager.dart';
import 'package:talkios/core/constant/icon_constant.dart';
import 'package:talkios/core/enum/preference_keys.dart';
import 'package:talkios/product/auth/welcome/welcome_view.dart';
import 'package:talkios/product/profile/model/button_model.dart';
import 'package:talkios/product/profile/view/account_settings_view.dart';
import 'package:talkios/product/profile/view/personal_information_view.dart';

class ProfileViewModel extends ChangeNotifier {
  // Variables
  int _buttonIndex = -1;
  int get buttonIndex => _buttonIndex;

  // Buttons
  List<ButtonModel> buttons = [
    ButtonModel(
        text: "Personal Information",
        icon: IconConstant.instance.personalInformation),
    ButtonModel(
        text: "Account Settings", icon: IconConstant.instance.accountSettings),
    ButtonModel(text: "Your Level", icon: IconConstant.instance.award),
    ButtonModel(text: "Statistics", icon: IconConstant.instance.statistics),
    ButtonModel(text: "Language", icon: IconConstant.instance.language),
    ButtonModel(text: "Write Us", icon: IconConstant.instance.writeUs),
    ButtonModel(
        text: "Terms and Conditions", icon: IconConstant.instance.terms),
  ];

  // Functions
  void logOut(BuildContext context) {
    String? token = CacheManager().getString(PreferencesKeys.TOKEN.toString());
    if (token!.isNotEmpty) {
      CacheManager().clear();
      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const WelcomeView()),
          (Route<dynamic> route) => false,
        );
      });
    }
  }

  void handleButtonPressed(BuildContext context, int index, String pageTitle,
      {String? profilePhoto, String? name}) {
    _buttonIndex = index;
    notifyListeners();

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PersonalInformationView(
              name: name!,
              profilePhoto: profilePhoto!,
              pageTitle: pageTitle,
            ),
          ),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AccountSettingsView(
              pageTitle: pageTitle,
            ),
          ),
        );
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
      case 5:
        break;
      case 6:
        break;
      default:
    }
  }
}
