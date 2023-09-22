// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:talkios/core/cache/cache_manager.dart';
import 'package:talkios/core/constant/color_constant.dart';
import 'package:talkios/core/constant/icon_constant.dart';
import 'package:talkios/core/enum/preference_keys.dart';
import 'package:talkios/core/util/pagination/complete_register_view.dart';
import 'package:talkios/core/util/pagination/interested_view.dart';
import 'package:talkios/core/util/pagination/language_view.dart';
import 'package:talkios/core/util/pagination/level_view.dart';
import 'package:talkios/core/util/pagination/practice_view.dart';
import 'package:talkios/core/util/pagination/target_view.dart';
import 'package:talkios/core/util/pagination/time_view.dart';
import 'package:talkios/product/auth/register/model/english_level_model.dart';
import 'package:talkios/product/auth/register/model/language_model.dart';
import 'package:talkios/product/auth/register/model/target_model.dart';
import 'package:talkios/product/auth/register/model/time_model.dart';
import 'package:talkios/product/auth/register/register_service.dart';
import 'package:talkios/product/auth/register/view/pagination_view.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'model/interest_model.dart';

class RegisterViewModel extends ChangeNotifier {
  // Service
  RegisterService service = RegisterService();

  // Pagination
  int _currentPage = 0;
  int get currentPage => _currentPage;

  late PageController pageController;

  RegisterViewModel() {
    pageController = PageController();
  }

  // Pagination Page Color
  final List<Color> pageBackgroundColor = [
    ColorConstant.instance.softPink,
    ColorConstant.instance.softCyan,
    ColorConstant.instance.yellow,
    ColorConstant.instance.softLightGreen,
    ColorConstant.instance.softPurple,
    ColorConstant.instance.softBlue,
    ColorConstant.instance.purple,
  ];

  // Pages
  List<Widget> get pages {
    return [
      LanguageView(pageController: pageController),
      LevelView(pageController: pageController),
      TargetView(pageController: pageController),
      TimeView(pageController: pageController),
      PracticeView(pageController: pageController),
      InterestedView(pageController: pageController),
      const CompleteRegisterView(),
    ];
  }

  // Register Variable
  bool _isObscure = true;
  bool get isObscure => _isObscure;

  // Pagination Variable
  int _languageButtonIndex = -1;
  int get languageButtonIndex => _languageButtonIndex;

  int _levelButtonIndex = -1;
  int get levelButtonIndex => _levelButtonIndex;

  int _targetButtonIndex = -1;
  int get targetButtonIndex => _targetButtonIndex;

  int _timeButtonIndex = -1;
  int get timeButtonIndex => _timeButtonIndex;

  double _completeValue = 0.0;
  double get completeValue => _completeValue;

  String _languageCode = "en";
  String get languageCode => _languageCode;

  String _levelCode = "A1";
  String get levelCode => _levelCode;

  int _targetId = 1;
  int get targetId => _targetId;

  String _selectedTime = "5";
  String get selectedTime => _selectedTime;

  bool _isTap = false;
  bool get isTap => _isTap;

  final List<int> _selectedInterestItems = [];
  List<int> get selectedInterestItems => _selectedInterestItems;

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

  List<EnglishLevelModel> englishLevels = [
    EnglishLevelModel(text: "Beginner", code: "A1"),
    EnglishLevelModel(text: "Basic knowledge", code: "A2"),
    EnglishLevelModel(text: "Conversational", code: "B1"),
    EnglishLevelModel(text: "Fluent", code: "B2"),
    EnglishLevelModel(text: "Advanced", code: "C1"),
    EnglishLevelModel(text: "Mastery", code: "C2"),
  ];

  List<TargetModel> targets = [
    TargetModel(text: "Learn at basic level", id: 1),
    TargetModel(text: "Be able to chat in english", id: 2),
    TargetModel(text: "Watch movies in english", id: 3),
    TargetModel(text: "I know culture", id: 4),
    TargetModel(text: "Communicating with people", id: 5),
    TargetModel(text: "Be able to talk at work", id: 6),
    TargetModel(text: "Be successful in exams", id: 7),
    TargetModel(text: "To speak more fluently", id: 8),
  ];

  List<TimeModel> times = [
    TimeModel(text: "5 minutes a day", time: "5"),
    TimeModel(text: "10 minutes a day", time: "10"),
    TimeModel(text: "15 minutes or more", time: "15"),
  ];

  List<InterestModel> interests = [
    InterestModel(id: 1, text: "Trip"),
    InterestModel(id: 2, text: "Food"),
    InterestModel(id: 3, text: "Nature"),
    InterestModel(id: 4, text: "Technology"),
    InterestModel(id: 5, text: "Languages"),
    InterestModel(id: 6, text: "Fashion"),
    InterestModel(id: 7, text: "Animals"),
    InterestModel(id: 8, text: "Culture"),
    InterestModel(id: 9, text: "Shopping"),
    InterestModel(id: 10, text: "Music"),
    InterestModel(id: 11, text: "Game"),
    InterestModel(id: 12, text: "Sport"),
    InterestModel(id: 13, text: "Health"),
  ];

  // Controller
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  // Key
  GlobalKey loginKey = GlobalKey();

  // FocusNode
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();

  // Function
  Future register(BuildContext context, Map<String, dynamic> userInfo) async {
    final response = await service.register(userInfo);

    if (response.result!) {
      String _token = response.data!.token!;
      CacheManager().setString(PreferencesKeys.TOKEN.toString(), _token);
      Future.delayed(
        const Duration(milliseconds: 300),
        () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const PaginationView()),
            (Route<dynamic> route) => false,
          );
        },
      );
    } else {
      String _message = response.validationError!.email![0];
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: _message,
        ),
      );
    }
  }

  Future updateProfileInfo(
      Map<String, dynamic> userInfo, PageController _pageController) async {
    String? _token = CacheManager().getString(PreferencesKeys.TOKEN.toString());
    final response = await service.updateProfileInfo(_token!, userInfo);

    if (response.result!) {
      Future.delayed(
        const Duration(milliseconds: 650),
        () {
          RegisterViewModel.goToNextPage(_pageController);
        },
      );
    } else {
      // Not okay
    }
  }

  void addItem(int item) {
    if (!_selectedInterestItems.contains(item)) {
      _selectedInterestItems.add(item);
      notifyListeners();
    }
  }

  void removeItem(int item) {
    if (_selectedInterestItems.contains(item)) {
      _selectedInterestItems.remove(item);
      notifyListeners();
    }
  }

  bool get buttonFillPercentage {
    return _selectedInterestItems.isEmpty ? false : true;
  }

  void tapButton() {
    _isTap = !_isTap;
    notifyListeners();
  }

  void changeLanguageCode(String code) {
    _languageCode = code;
    notifyListeners();
  }

  void changeLevelCode(String code) {
    _levelCode = code;
    notifyListeners();
  }

  void changeTargetId(int id) {
    _targetId = id;
    notifyListeners();
  }

  void changeTime(String time) {
    _selectedTime = time;
    notifyListeners();
  }

  void changeObscureText() {
    _isObscure = !_isObscure;
    notifyListeners();
  }

  void defocus() {
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();
    nameFocusNode.unfocus();
  }

  void setPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void setIndexToLanguageButton(int index) {
    _languageButtonIndex = index;
    notifyListeners();
  }

  void setIndexToLevelButton(int index) {
    _levelButtonIndex = index;
    notifyListeners();
  }

  void setIndexToTargetButton(int index) {
    _targetButtonIndex = index;
    notifyListeners();
  }

  void setIndexToTimeButton(int index) {
    _timeButtonIndex = index;
    notifyListeners();
  }

  set completeValue(double newValue) {
    _completeValue = newValue;
    notifyListeners();
  }

  static goToNextPage(PageController _pageController) {
    if (_pageController.hasClients &&
        _pageController.page != null &&
        _pageController.page! < 8) {
      // 2, son sayfanızın indeksi - 1'dir.
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  static goToPreviousPage(PageController _pageController) {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}
