import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:talkios/core/constant/api_constant.dart';
import 'package:talkios/product/home/model/scenario_model.dart';
import 'package:talkios/product/profile/model/profile_model.dart';

class HomeService {
  Future<ScenarioModel> getAllScenarios(String token) async {
    final response =
        await http.get(Uri.parse(ApiConstant.instance.scenarioUrl), headers: {
      "Authorization": "Bearer $token",
    });

    return ScenarioModel.fromJson(jsonDecode(response.body));
  }

  Future<ProfileModel> getProfileInfo(String token) async {
    final response =
        await http.get(Uri.parse(ApiConstant.instance.profilUrl), headers: {
      "Authorization": "Bearer $token",
    });

    return ProfileModel.fromJson(jsonDecode(response.body));
  }

  Future<void> sendPlayerIdToBackend(String playerId, String token) async {
    final response = await http.post(
      Uri.parse(ApiConstant.instance.playerId),
      headers: {
        "Authorization": "Bearer $token",
      },
      body: {
        'onesignal_player_id': playerId,
      },
    );

    if (response.statusCode == 200) {
      print('Player ID başarıyla gönderildi.');
    } else {
      print('Player ID gönderilirken bir hata oluştu: ${response.body}');
    }
  }
}
