import 'package:flutter/material.dart';
import 'package:talkios/core/view/base/base_stateless.dart';

class AppButton extends BaseStateless {
  final double widthValue;
  final double heightValue;
  final String text;
  final double borderRadius;
  final TextStyle? textStyle;
  final Color backgroundColor;
  final void Function() onPressed;
  final bool? isLoading;
  const AppButton({
    super.key,
    required this.widthValue,
    required this.heightValue,
    required this.text,
    required this.borderRadius,
    this.textStyle,
    required this.backgroundColor,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widthValue,
      height: heightValue,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          disabledForegroundColor: Colors.transparent,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed,
        child: isLoading!
            ? CircularProgressIndicator(
                strokeWidth: 2,
                color: color.background,
              )
            : Text(
                text,
                style: textStyle ??
                    currentTextTheme(context).bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: color.background,
                          fontSize: 14.0,
                          fontFamily: font.regular,
                        ),
              ),
      ),
    );
  }
}
