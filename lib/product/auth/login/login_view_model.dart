// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:talkios/core/cache/cache_manager.dart';
import 'package:talkios/core/enum/preference_keys.dart';
import 'package:talkios/core/util/provider/onesignal_service.dart';
import 'package:talkios/product/auth/login/login_service.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../home/view/new_home_view.dart';

class LoginViewModel extends ChangeNotifier {
  // Service
  LoginService service = LoginService();

  // Controller
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Key
  GlobalKey loginKey = GlobalKey();

  // FocusNode
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  // Variable
  bool _isObscure = true;
  bool get isObscure => _isObscure;

  bool _isTapButton = false;
  bool get isTapButton => _isTapButton;

  // Function
  Future login(BuildContext context, Map<String, dynamic> userInfo) async {
    final response = await service.login(userInfo);

    if (response.result != null) {
      if (response.result!) {
        String _token = response.data!.token!;
        await CacheManager()
            .setString(PreferencesKeys.TOKEN.toString(), _token);
        await OneSignalService.setUpOneSignal(isUsageDuration: false);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeView()),
          (Route<dynamic> route) => false,
        );
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            message: "Email or password is incorrect",
          ),
        );
      }
    } else {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: "Email or password is incorrect",
        ),
      );
    }
  }

  void tapButton() {
    _isTapButton = !_isTapButton;
    notifyListeners();
  }

  void defocus() {
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();
  }

  void changeObscureText() {
    _isObscure = !_isObscure;
    notifyListeners();
  }
}
