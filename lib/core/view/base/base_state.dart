import 'package:flutter/material.dart';
import 'package:talkios/core/constant/color_constant.dart';
import 'package:talkios/core/constant/font_constant.dart';
import 'package:talkios/core/constant/icon_constant.dart';
import 'package:talkios/core/constant/image_constant.dart';

import '../../constant/lottie_constant.dart';
import '../../constant/sound_constant.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  ThemeData get currentTheme => Theme.of(context);
  TextTheme get currentTextTheme => Theme.of(context).textTheme;

  FontConstant get font => FontConstant.instance;
  ColorConstant get color => ColorConstant.instance;
  IconConstant get icon => IconConstant.instance;
  ImageConstant get image => ImageConstant.instance;
  LottieConstant get lottie => LottieConstant.instance;
  SoundConstant get sound => SoundConstant.instance;

  double width(double value) => MediaQuery.of(context).size.width * value;
  double height(double value) => MediaQuery.of(context).size.height * value;

  SizedBox spacer({double? height, double? width}) =>
      SizedBox(width: width, height: height);

  EdgeInsets insetsAll(double val) => EdgeInsets.all(height(val));
  EdgeInsets insetsHorizontal(double val) =>
      EdgeInsets.symmetric(horizontal: height(val));
  EdgeInsets insetsVertical(double val) =>
      EdgeInsets.symmetric(vertical: height(val));

  Future push(Widget page) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => page),
      );

  Future pushAndRemoveUntil(Widget page) =>
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => page),
        (Route<dynamic> route) => false,
      );

  void back() => Navigator.pop(context);
}
