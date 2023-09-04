import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:talkios/core/constant/api_constant.dart';
import 'package:talkios/product/auth/login/login_model.dart';

class LoginService {
  Future<LoginModel> login(Map<String, dynamic> userInfo) async {
    final response = await http.post(
      Uri.parse(ApiConstant.instance.loginUrl),
      body: userInfo,
    );

    return LoginModel.fromJson(jsonDecode(response.body));
  }
}
