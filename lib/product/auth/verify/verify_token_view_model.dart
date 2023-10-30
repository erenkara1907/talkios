// ignore_for_file: unused_field, prefer_final_fields, use_build_context_synchronously, no_leading_underscores_for_local_identifiers, unused_local_variable

import 'package:flutter/material.dart';
import 'package:talkios/core/cache/cache_manager.dart';
import 'package:talkios/core/enum/preference_keys.dart';
import 'package:talkios/product/auth/forgot_password/view/reset_password_view.dart';
import 'package:talkios/product/auth/verify/verify_token_service.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../register/view/pagination_view.dart';

class VerifyTokenViewModel extends ChangeNotifier {
  final List<TextEditingController> controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  List<FocusNode> focusNodes = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  VerifyTokenService _service = VerifyTokenService();

  bool _isTapVerifyButton = false;
  bool get isTapVerifyButton => _isTapVerifyButton;

  bool _isTapResendButton = false;
  bool get isTapResendButton => _isTapResendButton;

  void tapResendButton() {
    _isTapResendButton = !_isTapResendButton;
    notifyListeners();
  }

  void tapVerifyButton() {
    _isTapVerifyButton = !_isTapVerifyButton;
    notifyListeners();
  }

  deFocus() {
    for (var i = 0; i < focusNodes.length; i++) {
      focusNodes[i].unfocus();
    }
  }

  Future<void> verifyToken(
    BuildContext context,
    String mail,
    String token,
  ) async {
    final response = await _service.verifyResetToken(mail, token);

    if (response.result != null && response.result!) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: "Email confirmed successfully",
        ),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => ResetPasswordView(
                  mail: mail,
                )),
        (Route<dynamic> route) => false,
      );
    } else {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: response.message ?? "Please check the pin you entered",
        ),
      );
    }
  }

  Future<void> forgotPassword(BuildContext context, String mail) async {
    final response = await _service.forgotPassword(mail);
    if (response.result != null && response.result!) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: "Password reset link has been sent to your email address",
        ),
      );
    } else {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "Please try again",
        ),
      );
    }
  }

  Future<void> verifyMail(
    BuildContext context,
    String mail,
    String code,
  ) async {
    String? _token = CacheManager().getString(PreferencesKeys.TOKEN.toString());
    final response = await _service.verifyMail(mail, code, _token!);
    if (response.message != null &&
        response.message == "E-mail verify succesfully") {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: "Your email has been confirmed successfully",
        ),
      );
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
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "Please check the pin you entered",
        ),
      );
    }
  }

  Future<void> resendVerifyMail(BuildContext context, String mail) async {
    String? _token = CacheManager().getString(PreferencesKeys.TOKEN.toString());
    final response = await _service.resendVerifyMail(mail, _token!);
    if (response.message != null &&
        response.message == "Verification email sent") {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: "Verification email sent",
        ),
      );
    } else {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "Please try again",
        ),
      );
    }
  }
}
