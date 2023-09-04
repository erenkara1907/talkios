// ignore_for_file: prefer_final_fields, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:talkios/core/cache/cache_manager.dart';
import 'package:talkios/core/constant/color_constant.dart';
import 'package:talkios/core/enum/preference_keys.dart';
import 'package:talkios/product/auth/register/view/pagination_view.dart';
import 'package:talkios/product/home/home_service.dart';
import 'package:talkios/product/profile/model/profile_model.dart';

import '../conversation/conversation_service.dart';
import '../conversation/view/conversation_room_view.dart';
import 'model/scenario_model.dart';

class HomeViewModel extends ChangeNotifier {
  // Service
  HomeService _service = HomeService();
  ConversationService _conversationService = ConversationService();

  // Model
  ProfileModel profileModel = ProfileModel();

  // Variable
  List<Scenarios> scenarios = [];

  List<Color> scenarioColors = [
    ColorConstant.instance.pink,
    ColorConstant.instance.cyan,
    ColorConstant.instance.yellow,
    ColorConstant.instance.lightGreen,
  ];

  bool _isTap = false;
  bool get isTap => _isTap;

  // Function
  void controlUserInformation(BuildContext context, ProfileModel model) {
    if (model.data!.user!.interestTitles!.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const PaginationView()),
          (Route<dynamic> route) => false,
        );
      });
    }
  }

  void tapButton() {
    _isTap = !_isTap;
    notifyListeners();
  }

  Future getProfileAndScenarios() async {
    await getProfileInfo();
    await getAllScenarios();
  }

  Future getAllScenarios() async {
    String? _token = CacheManager().getString(PreferencesKeys.TOKEN.toString());

    final response = await _service.getAllScenarios(_token!);
    if (response.result!) {
      scenarios.addAll(response.data!.scenarios!);
    } else {
      print("Hata oluştu");
    }
  }

  Future getProfileInfo() async {
    String? _token = CacheManager().getString(PreferencesKeys.TOKEN.toString());
    final response = await _service.getProfileInfo(_token!);

    if (response.result!) {
      profileModel = response;
    } else {
      print("Hata oluştu");
    }
  }

  Future storeConversation(
    BuildContext context,
    String scenarioId,
    String aiProfilePhoto,
    String userProfilePhoto,
  ) async {
    String? _token = CacheManager().getString(PreferencesKeys.TOKEN.toString());
    final respoonse =
        await _conversationService.storeConversation(_token!, scenarioId);

    if (respoonse.result!) {
      Future.delayed(
        const Duration(milliseconds: 300),
        () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConversationRoomView(
                aiProfilePhoto: aiProfilePhoto,
                userProfilePhoto: userProfilePhoto,
                conversationId: respoonse.data!.conversation!.id!,
              ),
            ),
          );
        },
      );
    } else {}
  }
}
