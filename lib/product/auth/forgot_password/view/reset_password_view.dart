// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/product/auth/forgot_password/viewmodel/reset_password_view_model.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../core/view/widget/button/app_button.dart';
import '../../../../core/view/widget/textfield/app_text_field.dart';

class ResetPasswordView extends BaseStateless {
  final String mail;
  ResetPasswordView({
    super.key,
    required this.mail,
  });
  ResetPasswordViewModel viewModel = ResetPasswordViewModel();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
            const Expanded(child: SizedBox()),
            Text(
              "Create a New Password",
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
                "Create a strong, new password for your account.",
                style: currentTextTheme(context).bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: color.dark50,
                      fontSize: 14.0,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            spacer(height: 15.0),
            form(context),
            const Expanded(flex: 9, child: SizedBox()),
            Selector<ResetPasswordViewModel, bool>(
              builder: (ctx, isTap, child) {
                return AnimatedPadding(
                  duration: const Duration(milliseconds: 300),
                  padding:
                      EdgeInsets.symmetric(horizontal: isTap ? 50.0 : 10.0),
                  child: AppButton(
                    widthValue: width(context: context, value: 1.0),
                    heightValue: height(context: context, value: 0.07),
                    text: 'Confirm New Password',
                    isLoading: isTap,
                    borderRadius: 66.0,
                    backgroundColor: color.dark100,
                    onPressed: () async {
                      if (viewModel.passwordController.text.isNotEmpty &&
                          viewModel.rePasswordController.text.isNotEmpty) {
                        context.read<ResetPasswordViewModel>().tapButton();
                        await viewModel.resetPassword(
                            context, mail, viewModel.passwordController.text);
                        context.read<ResetPasswordViewModel>().tapButton();
                      } else {
                        showTopSnackBar(
                          Overlay.of(context),
                          const CustomSnackBar.error(
                            message: "Please fill in the required fields",
                          ),
                        );
                      }
                    },
                  ),
                );
              },
              selector: (context, state) => state.isTapButton,
            ),
            const Expanded(flex: 2, child: SizedBox()),
          ],
        ),
      ),
    );
  }

  Form form(BuildContext context) {
    return Form(
      key: viewModel.loginKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Selector<ResetPasswordViewModel, bool>(
            builder: (ctx, isObscurePassword, child) {
              return Stack(
                children: [
                  AppTextField(
                    isObscure: isObscurePassword,
                    hintText: "Password",
                    controller: viewModel.passwordController,
                    focusNode: viewModel.passwordFocusNode,
                  ),
                  Positioned(
                    top: 0.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: IconButton(
                      onPressed: () => context
                          .read<ResetPasswordViewModel>()
                          .obscurePassword(),
                      icon: Icon(
                        isObscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: color.dark40,
                      ),
                    ),
                  ),
                ],
              );
            },
            selector: (context, state) => state.isObscurePassword,
          ),
          spacer(height: 16.0),
          Selector<ResetPasswordViewModel, bool>(
            builder: (ctx, isObscure, child) {
              return Stack(
                children: [
                  AppTextField(
                    isObscure: isObscure,
                    hintText: "Password Confirm",
                    controller: viewModel.rePasswordController,
                    focusNode: viewModel.rePasswordFocusNode,
                  ),
                  Positioned(
                    top: 0.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: IconButton(
                      onPressed: () => context
                          .read<ResetPasswordViewModel>()
                          .obscureRePassword(),
                      icon: Icon(
                        isObscure ? Icons.visibility_off : Icons.visibility,
                        color: color.dark40,
                      ),
                    ),
                  ),
                ],
              );
            },
            selector: (context, state) => state.isObscureRePassword,
          ),
        ],
      ),
    );
  }
}
