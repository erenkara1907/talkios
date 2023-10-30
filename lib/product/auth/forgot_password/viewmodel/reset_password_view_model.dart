// ignore_for_file: use_build_context_synchronously, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:talkios/product/auth/login/login_view.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../forgot_password_service.dart';

class ResetPasswordViewModel extends ChangeNotifier {
  // Service
  ForgotPasswordService _service = ForgotPasswordService();

  // Controller
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();

  // Key
  GlobalKey loginKey = GlobalKey();

  // FocusNode
  FocusNode passwordFocusNode = FocusNode();
  FocusNode rePasswordFocusNode = FocusNode();

  // Function
  void defocus() {
    passwordFocusNode.unfocus();
    rePasswordFocusNode.unfocus();
  }

  // Variable
  bool _isObscurePassword = true;
  bool get isObscurePassword => _isObscurePassword;

  bool _isObscureRePassword = true;
  bool get isObscureRePassword => _isObscureRePassword;

  bool _isTapButton = false;
  bool get isTapButton => _isTapButton;

  void tapButton() {
    _isTapButton = !_isTapButton;
    notifyListeners();
  }

  void obscurePassword() {
    _isObscurePassword = !_isObscurePassword;
    notifyListeners();
  }

  void obscureRePassword() {
    _isObscureRePassword = !_isObscureRePassword;
    notifyListeners();
  }

  Future<void> resetPassword(
      BuildContext context, String mail, String password) async {
    final response = await _service.resetPassword(mail, password);
    if (response.result != null && response.result!) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: "Password changed successfully",
        ),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginView()),
        (Route<dynamic> route) => false,
      );
    }
  }
}
