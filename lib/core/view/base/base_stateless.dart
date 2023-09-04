import 'package:flutter/material.dart';
import 'package:talkios/core/constant/lottie_constant.dart';
import 'package:talkios/core/constant/sound_constant.dart';

import '../../constant/color_constant.dart';
import '../../constant/font_constant.dart';
import '../../constant/icon_constant.dart';
import '../../constant/image_constant.dart';

abstract class BaseStateless extends StatelessWidget {
  const BaseStateless({super.key});

  ThemeData currentTheme(BuildContext context) => Theme.of(context);
  TextTheme currentTextTheme(BuildContext context) =>
      Theme.of(context).textTheme;

  FontConstant get font => FontConstant.instance;
  ColorConstant get color => ColorConstant.instance;
  IconConstant get icon => IconConstant.instance;
  ImageConstant get image => ImageConstant.instance;
  LottieConstant get lottie => LottieConstant.instance;
  SoundConstant get sound => SoundConstant.instance;

  double width({required BuildContext context, required double value}) {
    return MediaQuery.of(context).size.width * value;
  }

  double height({required BuildContext context, required double value}) {
    return MediaQuery.of(context).size.height * value;
  }

  SizedBox spacer({double? height, double? width}) =>
      SizedBox(height: height, width: width);

  EdgeInsets insetsAll(double val, BuildContext context) =>
      EdgeInsets.all(height(context: context, value: val));
  EdgeInsets insetsHorizontal(double val, BuildContext context) =>
      EdgeInsets.symmetric(horizontal: height(context: context, value: val));
  EdgeInsets insetsVertical(double val, BuildContext context) =>
      EdgeInsets.symmetric(vertical: height(context: context, value: val));

  Future push(BuildContext context, Widget page) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      );

  Future pushAndRemoveUntil(BuildContext context, Widget page) =>
     Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => page),
        (Route<dynamic> route) => false,
      );

  void back(BuildContext context) => Navigator.pop(context);
}
