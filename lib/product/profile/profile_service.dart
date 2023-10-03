import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:talkios/core/constant/api_constant.dart';
import 'package:talkios/product/profile/model/update_profile_model.dart';

class ProfileService {
  Future<UpdateProfileModel> updateProfileInfo(
      String token, Map<String, dynamic> info) async {
    final response = await http.post(
      Uri.parse(ApiConstant.instance.profilUrl),
      headers: {
        "Authorization": "Bearer $token",
      },
      body: info,
    );

    return UpdateProfileModel.fromJson(jsonDecode(response.body));
  }

  Future<UpdateProfileModel> updateBoolValues(
      String token, Map<String, dynamic> info) async {
    final response = await http.post(
      Uri.parse(ApiConstant.instance.profilUrl),
      headers: {
        "Authorization": "Bearer $token",
      },
      body: json.encode(info),
    );

    return UpdateProfileModel.fromJson(jsonDecode(response.body));
  }

  Future<UpdateProfileModel> updateName(String token, String name) async {
    final response = await http.post(
      Uri.parse(ApiConstant.instance.profilUrl),
      headers: {
        "Authorization": "Bearer $token",
      },
      body: {
        "name": name,
      },
    );

    return UpdateProfileModel.fromJson(jsonDecode(response.body));
  }
}
