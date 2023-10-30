// ignore_for_file: must_be_immutable, unused_local_variable, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/product/auth/verify/verify_token_view_model.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../core/view/widget/button/app_button.dart';

class VerifyTokenView extends BaseStateless {
  VerifyTokenViewModel viewModel = VerifyTokenViewModel();
  final String isRedirect;
  final String mail;
  final bool? isCloseBack;
  VerifyTokenView({
    super.key,
    required this.isRedirect,
    required this.mail,
    this.isCloseBack = false,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => viewModel.deFocus(),
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                image.background,
                fit: BoxFit.cover,
              ),
            ),
            view(context),
          ],
        ),
      ),
    );
  }

  Positioned view(BuildContext context) {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(child: SizedBox()),
            isCloseBack!
                ? const Center()
                : Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () => back(context),
                      icon: Icon(icon.arrowBack),
                    ),
                  ),
            isCloseBack! ? const Expanded(child: SizedBox()) : const Center(),
            const Expanded(child: SizedBox()),
            Text(
              "Enter Verification Code",
              style: currentTextTheme(context).bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: color.dark100,
                    fontSize: 24.0,
                  ),
            ),
            spacer(height: 15.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 66.0),
              child: Text(
                "Enter code that we have sent to your email $mail",
                style: currentTextTheme(context).bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: color.dark50,
                      fontSize: 14.0,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            spacer(height: 15.0),
            // form(context),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  viewModel.controllers.length,
                  (index) => _buildPinEntry(
                    context,
                    index,
                  ),
                ),
              ),
            ),
            const Expanded(flex: 9, child: SizedBox()),
            Selector<VerifyTokenViewModel, bool>(
              builder: (ctx, isTap, child) {
                return AnimatedPadding(
                  duration: const Duration(milliseconds: 300),
                  padding:
                      EdgeInsets.symmetric(horizontal: isTap ? 50.0 : 10.0),
                  child: AppButton(
                    widthValue: width(context: context, value: 1.0),
                    heightValue: height(context: context, value: 0.07),
                    text: 'Verify Code',
                    isLoading: isTap,
                    borderRadius: 66.0,
                    backgroundColor: color.dark100,
                    onPressed: () async {
                      String _pin = getEnteredPin();
                      if (_pin.length == 4) {
                        context.read<VerifyTokenViewModel>().tapVerifyButton();
                        if (isRedirect == "Forgot Password") {
                          await viewModel.verifyToken(
                            context,
                            mail,
                            _pin,
                          );
                        } else {
                          await viewModel.verifyMail(
                            context,
                            mail,
                            _pin,
                          );
                        }
                        context.read<VerifyTokenViewModel>().tapVerifyButton();
                      } else {
                        showTopSnackBar(
                          Overlay.of(context),
                          const CustomSnackBar.error(
                            message: "Your PIN code must be 4 digits.",
                          ),
                        );
                      }
                    },
                  ),
                );
              },
              selector: (context, state) => state.isTapVerifyButton,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: TextButton(
                style:
                    TextButton.styleFrom(splashFactory: NoSplash.splashFactory),
                onPressed: () async {
                  context.read<VerifyTokenViewModel>().tapResendButton();
                  if (isRedirect == "Forgot Password") {
                    await viewModel.forgotPassword(context, mail);
                  } else {
                    await viewModel.resendVerifyMail(context, mail);
                  }
                  context.read<VerifyTokenViewModel>().tapResendButton();
                },
                child: Selector<VerifyTokenViewModel, bool>(
                  builder: (ctx, isTap, child) {
                    return isTap
                        ? SizedBox(
                            width: 32.0,
                            height: 32.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              color: color.dark100,
                            ),
                          )
                        : Text(
                            "Resend Code",
                            style:
                                currentTextTheme(context).bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: color.dark80,
                                      fontSize: 12.0,
                                      fontFamily: font.semiBold,
                                    ),
                          );
                  },
                  selector: (context, state) => state.isTapResendButton,
                ),
              ),
            ),
            const Expanded(flex: 2, child: SizedBox()),
          ],
        ),
      ),
    );
  }

  Widget _buildPinEntry(
    BuildContext context,
    int index,
  ) {
    return SizedBox(
      width: 73.0,
      height: 50.0,
      child: TextField(
        focusNode: viewModel.focusNodes[index],
        autofocus: true,
        controller: viewModel.controllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          textBaseline: TextBaseline.alphabetic,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10.0),
          counterText: "",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              width: 1.0,
              color: color.dark20,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              width: 1.0,
              color: color.dark20,
            ),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < viewModel.focusNodes.length - 1) {
            FocusScope.of(context)
                .requestFocus(viewModel.focusNodes[index + 1]);
          }
          _checkIfAllFilled(context);
        },
        onEditingComplete: () {
          _checkIfAllFilled(context);
        },
        inputFormatters: [
          TextInputFormatter.withFunction(
            (oldValue, newValue) {
              // Geri tuşuna basıldığında
              if (newValue.text.isEmpty &&
                  oldValue.text.isNotEmpty &&
                  index != 0) {
                // Önceki kutucuğa odaklan
                viewModel.focusNodes[index - 1].requestFocus();
              }
              return newValue;
            },
          ),
        ],
      ),
    );
  }

  void _checkIfAllFilled(BuildContext context) {
    for (var controller in viewModel.controllers) {
      if (controller.text.isEmpty) {
        return; // Eğer boş kutucuk varsa, sonlandır.
      }
    }
    // Tüm kutucuklar dolduruldu.
    FocusScope.of(context).unfocus(); // Klavyeyi kapat.
  }

  String getEnteredPin() {
    String pin = "";
    for (var controller in viewModel.controllers) {
      pin += controller.text;
    }
    return pin;
  }
}
