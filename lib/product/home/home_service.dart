import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:talkios/core/constant/api_constant.dart';
import 'package:talkios/product/home/model/scenario_model.dart';
import 'package:talkios/product/profile/model/profile_model.dart';

import 'model/purchase_api_model.dart';

class HomeService {
  Future<ScenarioModel> getAllScenarios(String token) async {
    final response =
        await http.get(Uri.parse(ApiConstant.instance.scenarioUrl), headers: {
      "Authorization": "Bearer $token",
    });

    print("response : ${response.body}");

    return ScenarioModel.fromJson(jsonDecode(response.body));
  }

  Future<ProfileModel> getProfileInfo(String token) async {
    final response =
        await http.get(Uri.parse(ApiConstant.instance.profilUrl), headers: {
      "Authorization": "Bearer $token",
    });

    return ProfileModel.fromJson(jsonDecode(response.body));
  }

  Future<PurchaseAPIModel> purchaseInfo(String token) async {
    final response =
        await http.get(Uri.parse(ApiConstant.instance.purchaseUrl), headers: {
      "Authorization": "Bearer $token",
    });

    return PurchaseAPIModel.fromJson(jsonDecode(response.body));
  }
}
