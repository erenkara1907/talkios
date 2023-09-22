// ignore_for_file: deprecated_member_use, constant_pattern_never_matches_value_type, use_build_context_synchronously

import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/cache/cache_manager.dart';
import 'package:talkios/core/constant/color_constant.dart';
import 'package:talkios/core/constant/font_constant.dart';
import 'package:talkios/core/constant/icon_constant.dart';
import 'package:talkios/core/enum/preference_keys.dart';
import 'package:talkios/core/util/provider/image/image_upload_view_model.dart';
import 'package:talkios/core/view/widget/text/select_list_text.dart';
import 'package:talkios/product/auth/register/model/english_level_model.dart';
import 'package:talkios/product/auth/welcome/welcome_view.dart';
import 'package:talkios/product/profile/model/button_model.dart';
import 'package:talkios/product/profile/profile_service.dart';
import 'package:talkios/product/profile/view/account_settings_view.dart';
import 'package:talkios/product/profile/view/personal_information_view.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../auth/register/model/language_model.dart';
import '../auth/register/model/time_model.dart';
import 'model/profile_model.dart';

class ProfileViewModel extends ChangeNotifier {
  // Services
  final ProfileService _service = ProfileService();

  // Variables
  int _buttonIndex = -1;
  int get buttonIndex => _buttonIndex;

  bool _isProfilePhoto = false;
  bool get isProfilePhoto => _isProfilePhoto;

  String _skillLevel = "";
  String get skillLevel => _skillLevel;

  String _levelCode = "";
  String get levelCode => _levelCode;

  String _sessionLength = "";
  String get sessionLength => _sessionLength;

  String _sessionTime = "";
  String get sessionTime => _sessionTime;

  String _language = "";
  String get language => _language;

  String _languageCode = "";
  String get languageCode => _languageCode;

  String _practice = "";
  String get practice => _practice;

  bool _isListenExercise = false;
  bool get isListenExercise => _isListenExercise;

  bool _isSoundEffect = false;
  bool get isSoundEffect => _isSoundEffect;

  bool _isVibration = false;
  bool get isVibration => _isVibration;

  bool _isNotification = false;
  bool get isNotification => _isNotification;

  bool _isReminder = false;
  bool get isReminder => _isReminder;

  // Levels
  List<EnglishLevelModel> levels = [
    EnglishLevelModel(
      text: "Beginner",
      code: "A1",
    ),
    EnglishLevelModel(
      text: "Basic nowledge",
      code: "A2",
    ),
    EnglishLevelModel(
      text: "Conversational",
      code: "B1",
    ),
    EnglishLevelModel(
      text: "Fluent",
      code: "B2",
    ),
    EnglishLevelModel(
      text: "Advanced",
      code: "C1",
    ),
    EnglishLevelModel(
      text: "Mastery",
      code: "C2",
    ),
  ];

  // Practice
  List<String> practices = [
    "00:00",
    "01:00",
    "02:00",
    "03:00",
    "04:00",
    "05:00",
    "06:00",
    "07:00",
    "08:00",
    "09:00",
    "10:00",
    "11:00",
    "12:00",
    "13:00",
    "14:00",
    "15:00",
    "16:00",
    "17:00",
    "18:00",
    "19:00",
    "20:00",
    "21:00",
    "22:00",
    "23:00",
  ];

  // Times
  List<TimeModel> times = [
    TimeModel(time: "5", text: "5 minutes a day"),
    TimeModel(time: "10", text: "10 minutes a day"),
    TimeModel(time: "15", text: "15 minutes or more"),
  ];

  // Languages
  List<LanguageModel> languages = [
    LanguageModel(
      id: 1,
      code: "en",
      text: "English",
      flag: IconConstant.instance.englandFlag,
    ),
    LanguageModel(
      code: "tr",
      id: 2,
      text: "Turkish",
      flag: IconConstant.instance.turkeyFlag,
    ),
    LanguageModel(
      id: 3,
      code: "es",
      text: "Spanish",
      flag: IconConstant.instance.spainFlag,
    ),
    LanguageModel(
      id: 4,
      code: "de",
      text: "German",
      flag: IconConstant.instance.germanyFlag,
    ),
    LanguageModel(
      id: 5,
      code: "pt",
      text: "Portuguese",
      flag: IconConstant.instance.portugalFlag,
    ),
    LanguageModel(
      code: "fr",
      id: 6,
      text: "French",
      flag: IconConstant.instance.franceFlag,
    ),
    LanguageModel(
      code: "zh",
      id: 7,
      text: "Chinese",
      flag: IconConstant.instance.chinaFlag,
    ),
    LanguageModel(
      code: "ar",
      id: 8,
      text: "Arabic",
      flag: IconConstant.instance.saudiFlag,
    ),
    LanguageModel(
      code: "ru",
      id: 9,
      text: "Russian",
      flag: IconConstant.instance.russianFlag,
    ),
  ];

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
  Future updateProfileInfo(
      BuildContext context, Map<String, dynamic> info) async {
    String? token = CacheManager().getString(PreferencesKeys.TOKEN.toString());
    final response = await _service.updateProfileInfo(token!, info);
    if (response.result!) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: "Success",
        ),
      );
    }
  }

  void listenExercise() {
    _isListenExercise = !_isListenExercise;
    notifyListeners();
  }

  void soundEffect() {
    _isSoundEffect = !_isSoundEffect;
    notifyListeners();
  }

  void vibration() {
    _isVibration = !_isVibration;
    notifyListeners();
  }

  void showModal(bool isProfile) {
    _isProfilePhoto = isProfile;
    notifyListeners();
  }

  void notification() {
    _isNotification = !_isNotification;
    notifyListeners();
  }

  void reminder() {
    _isReminder = !_isReminder;
    notifyListeners();
  }

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
      {String? profilePhoto,
      String? name,
      required ProfileModel profileModel}) {
    _buttonIndex = index;
    notifyListeners();

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PersonalInformationView(
              profileModel: profileModel,
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
              profileModel: profileModel,
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

  void showLevelPicker(
    BuildContext context,
    String modelListType,
    ProfileModel profileModel,
  ) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: BoxDecoration(
            color: ColorConstant.instance.background,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: const Text("İptal"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    CupertinoButton(
                      child: const Text("Tamam"),
                      onPressed: () async {
                        // Seçilen dili işleyin (örn. bir durum yönetimi aracı veya başka bir şekilde kaydedin)
                        await updateProfileInfo(
                          context,
                          {
                            "native_language_code": languageCode.isNotEmpty
                                ? languageCode
                                : profileModel.data!.user!.nativeLanguage!.code,
                            "learn_language_proficiency_cefr":
                                levelCode.isNotEmpty
                                    ? levelCode
                                    : profileModel
                                        .data!
                                        .user!
                                        .learnLanguages![0]
                                        .proficiencyLevel!
                                        .cefr,
                            "session_length": sessionTime.isNotEmpty
                                ? sessionTime
                                : profileModel
                                    .data!.user!.userDetail!.sessionLength,
                            "time_of_reminder": practice.isNotEmpty
                                ? practice
                                : profileModel
                                    .data!.user!.userDetail!.timeOfReminder,
                          },
                        );
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  onSelectedItemChanged: (int index) =>
                      selectListItem(context, modelListType, index),
                  itemExtent: 30.0,
                  children: selectList(modelListType).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String> selectListItem(
      BuildContext context, String listType, int index) async {
    switch (listType) {
      case "Level":
        _skillLevel = levels[index].text;
        _levelCode = levels[index].code;
        notifyListeners();
        return _skillLevel;
      case "Time":
        _sessionLength = times[index].text;
        _sessionTime = times[index].time;
        notifyListeners();
        return _sessionLength;
      case "Language":
        _language = languages[index].text;
        _languageCode = languages[index].code;
        notifyListeners();
        return _language;
      case "Practice":
        _practice = practices[index];
        notifyListeners();
        return _language;
      default:
        return "Default";
    }
  }

  List<Widget> selectList(String listType) {
    switch (listType) {
      case "Level":
        return levels
            .map((item) => Center(child: SelectListText(text: item.text)))
            .toList();
      case "Time":
        return times
            .map((item) => Center(child: SelectListText(text: item.text)))
            .toList();
      case "Language":
        return languages
            .map((item) => Center(child: SelectListText(text: item.text)))
            .toList();
      case "Practice":
        return practices
            .map((item) => Center(child: SelectListText(text: item)))
            .toList();
      default:
        return levels
            .map((item) => Center(child: SelectListText(text: item.text)))
            .toList();
    }
  }

  void showEditProfile(
      BuildContext context, String profilePhoto, String username) {
    Navigator.of(context, rootNavigator: true).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Selector<ProfileViewModel, bool>(
                  builder: (context, isProfile, child) {
                    return isProfile
                        ? profileModal(context, profilePhoto)
                        : usernameModal(username, context);
                  },
                  selector: (context, state) => state.isProfilePhoto,
                ),
              ),
            ),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  Center usernameModal(String username, BuildContext context) {
    return Center(
      child: Hero(
        tag: "username",
        child: Material(
          type: MaterialType.transparency,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: TextFormField(
              style: TextStyle(
                color: ColorConstant.instance.dark100,
                fontWeight: FontWeight.w400,
                fontSize: 14.0,
                fontFamily: FontConstant.instance.regular,
              ),
              initialValue: username,
              textAlign: TextAlign.center,
              onEditingComplete: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ),
    );
  }

  Align profileModal(BuildContext context, String profilePhoto) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Selector<ImageUploadViewModel, File?>(
                builder: (context, photo, child) {
                  return Hero(
                    tag: "profilePhoto",
                    child: photo == null
                        ? CircleAvatar(
                            radius: 80.0,
                            backgroundImage:
                                CachedNetworkImageProvider(profilePhoto),
                          )
                        : CircleAvatar(
                            radius: 80.0,
                            backgroundImage: FileImage(photo),
                          ),
                  );
                },
                selector: (context, state) => state.uploadedImageUrl,
              ),
              const SizedBox(height: 10.0),
              TextButton(
                onPressed: () {
                  context.read<ImageUploadViewModel>().uploadFile(context);
                },
                child: Text(
                  "Edit",
                  style: TextStyle(
                    color: ColorConstant.instance.softBlue,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: FontConstant.instance.regular,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
