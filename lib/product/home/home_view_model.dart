// ignore_for_file: prefer_final_fields, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:talkios/core/cache/cache_manager.dart';
import 'package:talkios/core/constant/color_constant.dart';
import 'package:talkios/core/constant/font_constant.dart';
import 'package:talkios/core/enum/preference_keys.dart';
import 'package:talkios/product/auth/register/view/pagination_view.dart';
import 'package:talkios/product/auth/verify/verify_token_view.dart';
import 'package:talkios/product/conversation/view/conversation_room_view.dart';
import 'package:talkios/product/home/home_service.dart';
import 'package:talkios/product/home/model/purchase_api_model.dart';
import 'package:talkios/product/profile/model/profile_model.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../auth/welcome/welcome_view.dart';
import '../conversation/conversation_service.dart';
import '../vocabulary/view/new_vocabulary_view.dart';
import 'model/scenario_model.dart';

class HomeViewModel extends ChangeNotifier {
  // Service
  HomeService _service = HomeService();
  ConversationService _conversationService = ConversationService();

  // Model
  ProfileModel profileModel = ProfileModel();
  PurchaseAPIModel purchaseModel = PurchaseAPIModel();

  // Variable
  List<Scenarios> scenarios = [];
  List<Scenarios> completeScenario = [];

  List<Color> scenarioColors = [
    ColorConstant.instance.pink,
    ColorConstant.instance.cyan,
    ColorConstant.instance.yellow,
    ColorConstant.instance.lightGreen,
  ];

  bool _isTap = false;
  bool get isTap => _isTap;

  bool _isShowHomeView = false;
  bool get isShowHomeView => _isShowHomeView;

  bool _isTapVocabulary = false;
  bool get isTapVocabulary => _isTapVocabulary;

  bool _isTapLocked = false;
  bool get isTapLocked => _isTapLocked;

  int _scenarioIndex = -1;
  int get scenarioIndex => _scenarioIndex;

  set scenarioIndex(int value) {
    _scenarioIndex = value;
    notifyListeners();
  }

  void tapLock(bool isLock) {
    if (isLock) {
      _isTapLocked = true;
      notifyListeners();
    }
  }

  set isShowHomeView(bool value) {
    _isShowHomeView = value;
    notifyListeners();
  }

  bool isDialogShown = true;

  // Function
  void controlUserInformation(
      BuildContext context, ProfileModel model, List<Scenarios> scenarios) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scenarios.isNotEmpty) {
        print("scenario : ${scenarios[0].isLocked}");
      } else {
        print("scenarios listesi boş");
      }

      if (isDialogShown && model.data != null && model.data!.user != null) {
        if (model.data!.user!.emailVerified == null) {
          emailVerifiedDialog(context, model).then((value) {
            isDialogShown = false;
          });
        } else if (scenarios.isEmpty) {
          wizardDialog(context, model).then((value) {
            isDialogShown = false;
          });
        } else if (scenarios[0].isLocked == 1) {
          wizardDialog(context, model).then((value) {
            isDialogShown = false;
          });
        } else {
          isShowHomeView = true;
        }
      }
    });
  }

  List<WordScenario> newWordsFirst = [];
  List<WordScenario> newWordsSecond = [];

  Future<void> wordCheckFirst(List<WordScenario> words) async {
    newWordsFirst.clear();
    for (var i = 0; i < words.length; i++) {
      if (words[i].isComplete == false) {
        newWordsFirst.add(words[i]);
      }
    }
  }

  Future<void> wordCheckSecond(List<WordScenario> words) async {
    newWordsSecond.clear();
    for (var i = 0; i < words.length; i++) {
      if (words[i].isComplete == false) {
        newWordsSecond.add(words[i]);
      }
    }
  }

  Future<dynamic> emailVerifiedDialog(
      BuildContext context, ProfileModel model) {
    return showDialog(
      barrierDismissible: false,
      barrierColor: ColorConstant.instance.background,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 2.0,
            insetPadding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Email Verification Needed",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.instance.dark100,
                      fontFamily: FontConstant.instance.semiBold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Hello ${model.data!.user!.name},\n',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            fontFamily: FontConstant.instance.semiBold,
                            color: ColorConstant.instance.dark100,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Please verify your email to activate your account. A verification link has been sent.',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0,
                            fontFamily: FontConstant.instance.regular,
                            color: ColorConstant.instance.dark100,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                          child: CupertinoButton(
                            onPressed: () => logOut(context),
                            padding: EdgeInsets.zero,
                            color: Colors.red.withOpacity(0.6),
                            child: Text(
                              'Log out',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0,
                                  color: ColorConstant.instance.background,
                                  fontFamily: FontConstant.instance.semiBold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                          child: CupertinoButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => VerifyTokenView(
                                          isRedirect: 'Register',
                                          mail: model.data!.user!.email!,
                                          isCloseBack: true,
                                        )),
                                (Route<dynamic> route) => false,
                              );
                            },
                            padding: EdgeInsets.zero,
                            color: CupertinoColors.activeBlue,
                            child: Text(
                              'Confirm Email',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0,
                                  color: ColorConstant.instance.background,
                                  fontFamily: FontConstant.instance.semiBold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> wizardDialog(BuildContext context, ProfileModel model) {
    return showDialog(
      barrierDismissible: false,
      barrierColor: ColorConstant.instance.background,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 2.0,
            insetPadding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Complete Your Profile!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.instance.dark100,
                      fontFamily: FontConstant.instance.semiBold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Hello ${model.data!.user!.name},\n',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            fontFamily: FontConstant.instance.semiBold,
                            color: ColorConstant.instance.dark100,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Please finish setting up your profile to access all features of the app.',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0,
                            fontFamily: FontConstant.instance.regular,
                            color: ColorConstant.instance.dark100,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                          child: CupertinoButton(
                            onPressed: () => logOut(context),
                            padding: EdgeInsets.zero,
                            color: Colors.red.withOpacity(0.6),
                            child: Text(
                              'Log out',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0,
                                  color: ColorConstant.instance.background,
                                  fontFamily: FontConstant.instance.semiBold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04,
                          child: CupertinoButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const PaginationView(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            },
                            padding: EdgeInsets.zero,
                            color: CupertinoColors.activeBlue,
                            child: Text(
                              'Continue Setup',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0,
                                  color: ColorConstant.instance.background,
                                  fontFamily: FontConstant.instance.semiBold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
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

  void tapVocabulary() {
    _isTapVocabulary = !_isTapVocabulary;
    notifyListeners();
  }

  void tapButton() {
    _isTap = !_isTap;
    notifyListeners();
  }

  Future getProfileAndScenarios(BuildContext context) async {
    await Future.wait([
      getProfileInfo(context),
      getAllScenarios(context),
      purchaseInfo(),
    ]);
  }

  Future getAllScenarios(BuildContext context) async {
    String? _token = CacheManager().getString(PreferencesKeys.TOKEN.toString());

    if (_token != null) {
      final response = await _service.getAllScenarios(_token);
      if (response.result!) {
        scenarios.clear();
        completeScenario.clear();
        scenarios.addAll(response.data?.scenarios ?? []);
        for (var scenario in response.data?.scenarios ?? []) {
          if (scenario.isLocked == 0) {
            completeScenario.add(scenario);
          }
        }
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            message: "Something went wrong",
          ),
        );
      }
    }
  }

  Future getProfileInfo(BuildContext context) async {
    String? _token = CacheManager().getString(PreferencesKeys.TOKEN.toString());
    if (_token != null) {
      final response = await _service.getProfileInfo(_token);
      if (response.result!) {
        profileModel = response;
        CacheManager().setString(
          PreferencesKeys.LANGUAGE.toString(),
          response.data?.user?.nativeLanguage?.title?.toString() ?? '',
        );
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            message: "Something went wrong",
          ),
        );
      }
    }
  }

  Future purchaseInfo() async {
    String? _token = CacheManager().getString(PreferencesKeys.TOKEN.toString());
    if (_token != null) {
      final response = await _service.purchaseInfo(_token);
      if (response.result!) {
        purchaseModel = response;
      }
    }
  }

  int conversationId = -1;

  setConversationId(int id) {
    conversationId = id;
    notifyListeners();
  }

  Future storeConversation(
    BuildContext context,
    String scenarioId,
    String aiProfilePhoto,
    String userProfilePhoto,
    List<WordScenario> words,
    String scenarioName,
    String level,
    int score,
    bool isVocabulary,
    String gender,
  ) async {
    String? _token = CacheManager().getString(PreferencesKeys.TOKEN.toString());
    final respoonse =
        await _conversationService.storeConversation(_token!, scenarioId);

    if (respoonse.result!) {
      setConversationId(respoonse.data!.conversation!.id!);

      Future.delayed(
        const Duration(milliseconds: 300),
        () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => isVocabulary
                  ? NewVocabularyView(
                      color: Colors.blue,
                      gender: gender,
                      words: words,
                      aiProfilePhoto: aiProfilePhoto,
                      userProfilePhoto: userProfilePhoto,
                      conversationId: respoonse.data!.conversation!.id!,
                      level: level,
                      scenarioName: scenarioName,
                    )
                  : ConversationRoomView(
                      isActive: respoonse.data!.conversation!.isActive!,
                      gender: gender,
                      fromWhere: "detail",
                      score: score,
                      aiProfilePhoto: aiProfilePhoto,
                      userProfilePhoto: userProfilePhoto,
                      conversationId: respoonse.data!.conversation!.id!,
                      scenarioName: scenarioName,
                    ),
            ),
          );
        },
      );
    } else {}
  }
}
