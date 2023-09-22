import 'package:flutter/material.dart';
import 'package:talkios/core/view/base/base_stateless.dart';

class SelectListText extends BaseStateless {
  final String text;
  const SelectListText({
    super.key,
    required this.text,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        color: color.dark100,
        fontSize: 18.0,
        fontFamily: font.regular,
      ),
    );
  }
}
