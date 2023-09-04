import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:talkios/core/constant/api_constant.dart';
import 'package:talkios/product/auth/register/model/profile_update_model.dart';
import 'package:talkios/product/auth/register/model/register_model.dart';

class RegisterService {
  Future<RegisterModel> register(Map<String, dynamic> userInfo) async {
    final response = await http.post(
      Uri.parse(ApiConstant.instance.registerUrl),
      body: userInfo,
    );

    return RegisterModel.fromJson(jsonDecode(response.body));
  }

  Future<ProfileUpdateModel> updateProfileInfo(
      String token, Map<String, dynamic> userInfo) async {
    final response = await http.post(Uri.parse(ApiConstant.instance.profilUrl),
        body: userInfo,
        headers: {
          "Authorization": "Bearer $token",
        });


    return ProfileUpdateModel.fromJson(jsonDecode(response.body));
  }
}
