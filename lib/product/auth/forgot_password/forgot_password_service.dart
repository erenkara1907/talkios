import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:talkios/core/constant/api_constant.dart';
import 'package:talkios/product/auth/forgot_password/model/forgot_password_model.dart';
import 'package:talkios/product/auth/forgot_password/model/reset_password_model.dart';

class ForgotPasswordService {
  Future<ForgotPasswordModel> forgotPassword(String mail) async {
    final response =
        await http.post(Uri.parse(ApiConstant.instance.forgotPassword), body: {
      "email": mail,
    });

    return ForgotPasswordModel.fromJson(jsonDecode(response.body));
  }

  Future<ResetPasswordModel> resetPassword(String mail, String password) async {
    final response = await http.post(
        Uri.parse(
          ApiConstant.instance.resetPassword,
        ),
        body: {
          "email": mail,
          "password": password,
        });

    return ResetPasswordModel.fromJson(jsonDecode(response.body));
  }
}
