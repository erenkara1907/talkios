// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/product/auth/forgot_password/viewmodel/forgot_password_view_model.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../core/view/widget/button/app_button.dart';
import '../../../../core/view/widget/textfield/app_text_field.dart';

class ForgotPasswordView extends BaseStateless {
  ForgotPasswordView({Key? key}) : super(key: key);
  ForgotPasswordViewModel viewModel = ForgotPasswordViewModel();
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
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () => back(context),
                icon: Icon(icon.arrowBack),
              ),
            ),
            const Expanded(child: SizedBox()),
            Text(
              "Forgot Your Password?",
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
            Selector<ForgotPasswordViewModel, bool>(
              builder: (ctx, isTap, child) {
                return AnimatedPadding(
                  duration: const Duration(milliseconds: 300),
                  padding:
                      EdgeInsets.symmetric(horizontal: isTap ? 50.0 : 10.0),
                  child: AppButton(
                    widthValue: width(context: context, value: 1.0),
                    heightValue: height(context: context, value: 0.07),
                    text: 'Submit',
                    isLoading: isTap,
                    borderRadius: 66.0,
                    backgroundColor: color.dark100,
                    onPressed: () async {
                      if (viewModel.emailController.text.isNotEmpty) {
                        context.read<ForgotPasswordViewModel>().tapButton();
                        await viewModel.forgotPassword(
                            context, viewModel.emailController.text);
                        context.read<ForgotPasswordViewModel>().tapButton();
                      } else {
                        showTopSnackBar(
                          Overlay.of(context),
                          const CustomSnackBar.error(
                            message: "Please enter your email",
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
      child: AppTextField(
        hintText: "Email",
        controller: viewModel.emailController,
        focusNode: viewModel.emailFocusNode,
      ),
    );
  }
}
