import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/core/view/widget/button/app_button.dart';
import 'package:talkios/product/auth/login/login_view.dart';
import 'package:talkios/product/auth/register/view/register_view.dart';

class WelcomeView extends BaseStateless {
  const WelcomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.background,
      body: Stack(
        children: [
          Positioned(
            top: 0.0,
            left: 0.0,
            child: Image.asset(image.cyanEllipse),
          ),
          Positioned(
            top: 100.0,
            right: 0.0,
            child: Image.asset(image.blueEllipse),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(flex: 3, child: SizedBox()),
                  SvgPicture.asset(image.talkios),
                  spacer(height: 33.0),
                  Text(
                    "Hello! Are you ready to practice your language while having fun?",
                    style: currentTextTheme(context).bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: color.dark100,
                          fontSize: 18.0,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const Expanded(child: SizedBox()),
                  AppButton(
                    widthValue: width(context: context, value: 1.0),
                    heightValue: height(context: context, value: 0.06),
                    text: "Log in",
                    borderRadius: 66.0,
                    textStyle: currentTextTheme(context).bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: color.dark100,
                          fontSize: 14.0,
                        ),
                    backgroundColor: color.dark10,
                    onPressed: () => push(context, LoginView()),
                  ),
                  spacer(height: 12.0),
                  AppButton(
                    widthValue: width(context: context, value: 1.0),
                    heightValue: height(context: context, value: 0.06),
                    text: "Sign up",
                    borderRadius: 66.0,
                    textStyle: currentTextTheme(context).bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: color.background,
                          fontSize: 14.0,
                        ),
                    backgroundColor: color.dark100,
                    onPressed: () => push(context, RegisterView()),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
