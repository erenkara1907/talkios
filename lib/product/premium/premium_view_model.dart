// ignore_for_file: prefer_final_fields, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:talkios/core/cache/cache_manager.dart';
import 'package:talkios/core/constant/image_constant.dart';
import 'package:talkios/core/enum/preference_keys.dart';
import 'package:talkios/product/premium/premium_model.dart';
import 'package:talkios/product/premium/premium_service.dart';

import '../home/view/new_home_view.dart';

class PremiumViewModel extends ChangeNotifier {
  // Service
  PremiumService _service = PremiumService();
  int _currentPage = 0;
  int get currentPage => _currentPage;

  bool _isTap = false;
  bool get isTap => _isTap;

  set isTap(bool value) {
    _isTap = value;
    notifyListeners();
  }

  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  List<PremiumModel> pages = [
    PremiumModel(
      title: "Standard",
      image: ImageConstant.instance.pyramidOne,
      subTitle: "Talkios standard package is only 229₺ per month",
      advantageOne: "Unlimited word learning",
      advantageTwo: "One-on-one conversation with artificial intelligence",
      advantageThree: "Unlimited word learning",
    ),
    PremiumModel(
      title: "Yearly",
      image: ImageConstant.instance.pyramidTwo,
      subTitle: "Talkios standard package is only 229₺ per month",
      advantageOne: "Unlimited word learning",
      advantageTwo: "One-on-one conversation with artificial intelligence",
      advantageThree: "Unlimited word learning",
    ),
    PremiumModel(
      title: "Professional",
      image: ImageConstant.instance.pyramidThree,
      subTitle: "Talkios standard package is only 229₺ per month",
      advantageOne: "Unlimited word learning",
      advantageTwo: "One-on-one conversation with artificial intelligence",
      advantageThree: "Unlimited word learning",
    ),
  ];

  Future updatePurchase(BuildContext context) async {
    String? token = CacheManager().getString(PreferencesKeys.TOKEN.toString());
    if (token != null) {
      final response = await _service.purchaseUpdate(token);
      if (response.result!) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeView()),
          (Route<dynamic> route) => false,
        );
      }
    }
  }
}
