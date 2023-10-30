import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:talkios/product/auth/verify/verify_mail_model.dart';

import '../../../core/constant/api_constant.dart';
import '../forgot_password/model/forgot_password_model.dart';

class VerifyTokenService {
  Future<VerifyMailModel> verifyResetToken(
      String mail, String verifyToken) async {
    final response = await http.post(
        Uri.parse(
          ApiConstant.instance.verifyResetToken,
        ),
        body: {
          "email": mail,
          "token": verifyToken,
        });

    return VerifyMailModel.fromJson(jsonDecode(response.body));
  }

  Future<ForgotPasswordModel> forgotPassword(String mail) async {
    final response =
        await http.post(Uri.parse(ApiConstant.instance.forgotPassword), body: {
      "email": mail,
    });

    return ForgotPasswordModel.fromJson(jsonDecode(response.body));
  }

  Future<VerifyMailModel> verifyMail(
      String mail, String code, String token) async {
    final response = await http.post(
        Uri.parse(
          ApiConstant.instance.verifyMail,
        ),
        headers: {
          "Authorization": "Bearer $token",
        },
        body: {
          "email": mail,
          "code": code,
        });

    print("response : ${response.body}");


    return VerifyMailModel.fromJson(jsonDecode(response.body));
  }

  Future<VerifyMailModel> resendVerifyMail(String mail, String token) async {
    final response = await http.post(
      Uri.parse("${ApiConstant.instance.resendVerifyMail}?email=$mail"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );


    return VerifyMailModel.fromJson(jsonDecode(response.body));
  }
}
