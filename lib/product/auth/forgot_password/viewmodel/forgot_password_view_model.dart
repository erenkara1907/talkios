// ignore_for_file: unused_field, prefer_final_fields, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:talkios/product/auth/forgot_password/forgot_password_service.dart';
import 'package:talkios/product/auth/verify/verify_token_view.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  // Service
  ForgotPasswordService _service = ForgotPasswordService();

  // Controller
  TextEditingController emailController = TextEditingController();

  // Key
  GlobalKey loginKey = GlobalKey();

  // FocusNode
  FocusNode emailFocusNode = FocusNode();

  // Variable
  bool _isTapButton = false;
  bool get isTapButton => _isTapButton;

  tapButton() {
    _isTapButton = !_isTapButton;
    notifyListeners();
  }

  // Function
  void defocus() {
    emailFocusNode.unfocus();
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
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VerifyTokenView(
            mail: mail,
            isRedirect: "Forgot Password",
          ),
        ),
      );
    } else {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message:
              response.message ?? "Please enter a registered email address",
        ),
      );
    }
  }
}
