import 'package:flutter/material.dart';
import 'package:talkios/core/view/base/base_stateless.dart';

class AppTextField extends BaseStateless {
  final TextStyle? textStyle;
  final Color? cursorColor;
  final String hintText;
  final TextStyle? hintStyle;
  final Color? borderColor;
  final double? borderRadius;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool? isObscure;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    this.textStyle,
    this.cursorColor,
    required this.hintText,
    this.hintStyle,
    this.borderColor,
    this.borderRadius,
    required this.controller,
    required this.focusNode,
    this.isObscure = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObscure!,
      controller: controller,
      validator: validator,
      focusNode: focusNode,
      textAlign: TextAlign.center,
      style: textStyle ??
          currentTextTheme(context).bodyLarge?.copyWith(
                fontWeight: FontWeight.w400,
                color: color.dark80,
                fontSize: 16.0,
              ),
      cursorColor: cursorColor ?? color.dark20,
      decoration: InputDecoration(
        filled: false,
        hintText: hintText,
        hintStyle: hintStyle ??
            currentTextTheme(context).bodyLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: color.dark20,
                  fontSize: 16.0,
                ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 66.0),
          borderSide: BorderSide(
            width: 1.0,
            color: borderColor ?? color.dark20,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 66.0),
          borderSide: BorderSide(
            width: 1.0,
            color: borderColor ?? color.dark20,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 66.0),
          borderSide: BorderSide(
            width: 1.0,
            color: borderColor ?? color.dark20,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 66.0),
          borderSide: BorderSide(
            width: 1.0,
            color: borderColor ?? color.dark20,
          ),
        ),
      ),
    );
  }
}
