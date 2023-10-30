// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/core/view/widget/button/app_button.dart';
import 'package:talkios/core/view/widget/textfield/app_text_field.dart';
import 'package:talkios/product/auth/forgot_password/view/forgot_password_view.dart';
import 'package:talkios/product/auth/login/login_view_model.dart';
import 'package:talkios/product/auth/register/view/register_view.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

// ignore: must_be_immutable
class LoginView extends BaseStateless {
  LoginViewModel viewModel = LoginViewModel();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => viewModel.defocus(),
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                image.background,
                fit: BoxFit.cover,
              ),
            ),
            view(context)
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
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () => back(context),
                icon: Icon(icon.arrowBack),
              ),
            ),
            const Expanded(child: SizedBox()),
            Text(
              "Sign In",
              style: currentTextTheme(context).bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: color.dark50,
                    fontSize: 14.0,
                  ),
            ),
            spacer(height: 15.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 66.0),
              child: Text(
                "Please enter your information",
                style: currentTextTheme(context).bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: color.dark100,
                      fontSize: 24.0,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            spacer(height: 15.0),
            form(context),
            const Expanded(flex: 9, child: SizedBox()),
            Selector<LoginViewModel, bool>(
              builder: (context, isTap, child) {
                return AnimatedPadding(
                  duration: const Duration(milliseconds: 300),
                  padding:
                      EdgeInsets.symmetric(horizontal: isTap ? 50.0 : 10.0),
                  child: AppButton(
                    widthValue: width(context: context, value: 1.0),
                    heightValue: height(context: context, value: 0.07),
                    text: 'Sign In',
                    isLoading: isTap,
                    borderRadius: 66.0,
                    backgroundColor: color.dark100,
                    onPressed: () async {
                      if (viewModel.emailController.text.isNotEmpty &&
                          viewModel.passwordController.text.isNotEmpty) {
                        context.read<LoginViewModel>().tapButton();
                        await context.read<LoginViewModel>().login(
                          context,
                          {
                            "email": viewModel.emailController.text,
                            "password": viewModel.passwordController.text,
                          },
                        );
                        context.read<LoginViewModel>().tapButton();
                      } else {
                        showTopSnackBar(
                          Overlay.of(context),
                          const CustomSnackBar.error(
                            message: "Please fill in all fields",
                          ),
                        );
                      }
                    },
                  ),
                );
              },
              selector: (context, state) => state.isTapButton,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: TextButton(
                onPressed: () {
                  push(context, RegisterView());
                },
                child: Text(
                  "Join Now and Explore!",
                  style: currentTextTheme(context).bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: color.dark80,
                        fontSize: 12.0,
                        fontFamily: font.semiBold,
                      ),
                ),
              ),
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
        children: [
          AppTextField(
            hintText: "Email",
            controller: viewModel.emailController,
            focusNode: viewModel.emailFocusNode,
          ),
          spacer(height: 16.0),
          Consumer<LoginViewModel>(
            builder: (context, state, child) {
              return Stack(
                children: [
                  AppTextField(
                    isObscure: state.isObscure,
                    hintText: "Password",
                    controller: viewModel.passwordController,
                    focusNode: viewModel.passwordFocusNode,
                  ),
                  Positioned(
                    top: 0.0,
                    right: 0.0,
                    bottom: 0.0,
                    child: IconButton(
                      onPressed: () => state.changeObscureText(),
                      icon: Icon(
                        state.isObscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: color.dark40,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () => push(
                context,
                ForgotPasswordView(),
              ),
              child: Text(
                "Forgot Password?",
                style: currentTextTheme(context).bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: color.dark80,
                      fontSize: 12.0,
                      fontFamily: font.semiBold,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
