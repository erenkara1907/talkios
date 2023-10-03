// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:talkios/core/cache/cache_manager.dart';
import 'package:talkios/core/enum/preference_keys.dart';
import 'package:talkios/product/auth/login/login_service.dart';
import 'package:talkios/product/home/view/home_view.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../home/home_service.dart';

class LoginViewModel extends ChangeNotifier {
  // Service
  LoginService service = LoginService();
  final HomeService _service = HomeService();

  // Coontroller
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
    final playerId = OneSignal.User.pushSubscription.id;

    if (response.result != null) {
      if (response.result!) {
        await _service.sendPlayerIdToBackend(playerId!, response.data!.token!);
        String _token = response.data!.token!;
        CacheManager().setString(PreferencesKeys.TOKEN.toString(), _token);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeView()),
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

  Future takePlayerId() async {
    String? _token = CacheManager().getString(PreferencesKeys.TOKEN.toString());
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
