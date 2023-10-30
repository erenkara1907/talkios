// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/core/view/widget/button/app_button.dart';
import 'package:talkios/core/view/widget/textfield/app_text_field.dart';
import 'package:talkios/product/auth/login/login_view.dart';
import 'package:talkios/product/auth/register/register_view_model.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

// ignore: must_be_immutable
class RegisterView extends BaseStateless {
  RegisterViewModel viewModel = RegisterViewModel();
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
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            height: height(context: context, value: 1.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height(context: context, value: 0.05)),
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () => back(context),
                        icon: Icon(icon.arrowBack),
                      ),
                    ),
                    SizedBox(height: height(context: context, value: 0.04)),
                    Text(
                      "Sign Up",
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
                    form(),
                    spacer(height: 5.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Selector<RegisterViewModel, bool>(
                          builder: (ctx, isCheck, child) {
                            return Checkbox(
                              activeColor: color.dark100,
                              checkColor: color.background,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                              side: BorderSide(
                                color: color.dark50,
                              ),
                              value: isCheck,
                              onChanged: (value) {
                                if (value != null) {
                                  context
                                      .read<RegisterViewModel>()
                                      .isCheckedTerms = value;
                                }
                              },
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            );
                          },
                          selector: (context, state) => state.isCheckedTerms,
                        ),
                        TextButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 10.0, sigmaY: 10.0),
                                  child: FractionallySizedBox(
                                    heightFactor: 0.7,
                                    child: Container(
                                      height:
                                          height(context: context, value: 0.7),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                          top: Radius.circular(10.0),
                                        ),
                                        color: color.background,
                                      ),
                                      child: ListView(
                                        addSemanticIndexes: false,
                                        addAutomaticKeepAlives: false,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 24.0),
                                        shrinkWrap: true,
                                        physics: const ClampingScrollPhysics(),
                                        children: [
                                          Text(
                                            "Talkios Privacy Policy \nThis Privacy Policy applies to the collection, use, disclosure, and protection of personal data of users ('Users') of the Talkios application ('Application'). By using the Application, you accept this Privacy Policy. \n \nCollected Information \nThe Application may collect users' personal information such as voice recordings, chat history, username, email address, and performance data, including usage statistics.\n \nUse of Information \nThe collected information may be used for the following purposes: \n\n \na. Improving user experience \nb. Providing and enhancing the service \nc. Providing support to users \nd. Complying with legal obligations \n\n \nSharing of Information \nTalkios does not share user data with third parties, except when required by a legal request or necessary to protect the rights, safety, or property of users.\n \nSecurity \nTalkios takes appropriate technical and organizational measures to ensure the security of user data. However, please note that no transmission over the internet can be guaranteed as completely secure.\n \nChildren \nThe Application is not intended for use by individuals under the age of 13, and it does not knowingly collect personal information from this age group.\n \nChanges \nTalkios reserves the right to update this Privacy Policy from time to time. When changes are made, we will update the 'Last Updated' date at the top of this page.\n \nContact \nIf you have any questions or comments, please email [info@ron.digital].\n \nLast Updated: [03.07.2023]\n \nUser Rights\n \nUsers have the right to access, correct, delete, or restrict the processing of their collected personal data. Users also have the right to object to data processing. These rights are subject to applicable data protection laws.\n \nThird-Party Services\n \nTalkios may integrate third-party services within the application. The privacy practices of these third-party services are not covered by this agreement, and users are encouraged to review the privacy policies of these services.\n \nCookies and Similar Technologies\n \nThe Application may use cookies and similar technologies to enhance the user experience, perform statistical analysis, and personalize services. Users can manage these features through their device settings.\n \nOpt-Out and Account Deletion\n \nUsers can refuse the processing of their personal data or delete their Talkios accounts at any time. In the case of account deletion, user data may be retained for the appropriate legal period.\n \nInternational Data Transfers\n \nTalkios may store and process data on servers located in different jurisdictions. By using the Application, users consent to the processing and transfer of their data outside their jurisdiction.\n \nLaw and Jurisdiction\n \nThis Privacy Policy is governed by the laws of [Applicable Country/Jurisdiction], and users accept the jurisdiction of the [Applicable Country/Jurisdiction] courts.\n \nOn behalf of Talkios, \n[Ron Digital] \n[23 Nisan Mah, 242. Sok, Ata Bulvarı No:17 Guzell Tower İş Merkezi, 16230 Nilüfer/Bursa/Turkey] \n[info@ron.digital]",
                                            style: currentTextTheme(context)
                                                .bodyLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: color.dark90,
                                                  fontSize: 14.0,
                                                  fontFamily: font.regular,
                                                ),
                                            textAlign: TextAlign.start,
                                          ),
                                          spacer(height: 10.0),
                                          AppButton(
                                            widthValue: width(
                                                context: context, value: 1.0),
                                            heightValue: height(
                                                context: context, value: 0.06),
                                            text: "Accept Terms & Conditions",
                                            borderRadius: 66.0,
                                            backgroundColor: color.dark100,
                                            onPressed: () {
                                              context
                                                  .read<RegisterViewModel>()
                                                  .isCheckedTerms = true;
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "I Agree to The",
                                style: currentTextTheme(context)
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w300,
                                      color: color.dark80,
                                      fontSize: 12.0,
                                    ),
                              ),
                              Text(
                                " Terms and Conditions",
                                style: currentTextTheme(context)
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: color.dark100,
                                      fontSize: 12.0,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 38.0),
                  child: Column(
                    children: [
                      Selector<RegisterViewModel, bool>(
                        builder: (context, isTap, child) {
                          return AnimatedPadding(
                            duration: const Duration(milliseconds: 300),
                            padding: EdgeInsets.symmetric(
                                horizontal: isTap ? 50.0 : 10.0),
                            child: AppButton(
                              widthValue: width(context: context, value: 1.0),
                              heightValue:
                                  height(context: context, value: 0.07),
                              text: 'Sign Up',
                              isLoading: isTap,
                              borderRadius: 66.0,
                              backgroundColor: color.dark100,
                              onPressed: () async {
                                if (viewModel.registerKey.currentState
                                        ?.validate() ??
                                    false) {
                                  if (viewModel
                                          .nameController.text.isNotEmpty &&
                                      viewModel
                                          .emailController.text.isNotEmpty &&
                                      viewModel
                                          .passwordController.text.isNotEmpty &&
                                      context
                                          .read<RegisterViewModel>()
                                          .isCheckedTerms) {
                                    // context
                                    //     .read<RegisterViewModel>()
                                    //     .tapButton();
                                    await context
                                        .read<RegisterViewModel>()
                                        .register(
                                            context,
                                            {
                                              "email": viewModel
                                                  .emailController.text,
                                              "password": viewModel
                                                  .passwordController.text,
                                              "name":
                                                  viewModel.nameController.text,
                                            },
                                            viewModel.emailController.text);
                                    // context
                                    //     .read<RegisterViewModel>()
                                    //     .tapButton();
                                  } else {
                                    if (!context
                                        .read<RegisterViewModel>()
                                        .isCheckedTerms) {
                                      showTopSnackBar(
                                        Overlay.of(context),
                                        const CustomSnackBar.error(
                                          message:
                                              "Please accept the terms and conditions",
                                        ),
                                      );
                                    } else {
                                      showTopSnackBar(
                                        Overlay.of(context),
                                        const CustomSnackBar.error(
                                          message: "Please fill in all fields",
                                        ),
                                      );
                                    }
                                  }
                                }
                              },
                            ),
                          );
                        },
                        selector: (context, state) => state.isTap,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: TextButton(
                          onPressed: () {
                            push(context, LoginView());
                          },
                          child: Text(
                            "Have you joined us before? Log In",
                            style:
                                currentTextTheme(context).bodyLarge?.copyWith(
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Form form() {
    return Form(
      key: viewModel.registerKey,
      child: Column(
        children: [
          AppTextField(
            hintText: "First Name",
            controller: viewModel.nameController,
            focusNode: viewModel.nameFocusNode,
            validator: viewModel.validateName,
          ),
          spacer(height: 16.0),
          AppTextField(
            hintText: "Email",
            controller: viewModel.emailController,
            focusNode: viewModel.emailFocusNode,
          ),
          spacer(height: 16.0),
          Consumer<RegisterViewModel>(
            builder: (context, state, child) {
              return Stack(
                children: [
                  AppTextField(
                    isObscure: state.isObscure,
                    hintText: "Password",
                    controller: viewModel.passwordController,
                    focusNode: viewModel.passwordFocusNode,
                    validator: viewModel.validatePassword,
                  ),
                  Positioned(
                    right: 0.0,
                    top: 0.0,
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
        ],
      ),
    );
  }
}
