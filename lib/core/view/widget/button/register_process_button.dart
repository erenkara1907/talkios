import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:talkios/core/view/base/base_stateless.dart';

class RegisterProcessButton extends BaseStateless {
  final String text;
  final String? flag;
  final bool isLanguage;
  final bool isSelected;
  final void Function() onPressed;
  const RegisterProcessButton({
    super.key,
    required this.text,
    this.flag,
    required this.isLanguage,
    required this.isSelected,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width(context: context, value: 1.0),
      height: height(context: context, value: 0.07),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          backgroundColor: color.background.withOpacity(isSelected ? 0.4 : 0.2),
          foregroundColor: color.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(66.0),
            side: BorderSide(
              width: 1.0,
              color: color.background,
            ),
          ),
        ).copyWith(
            overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
          if (states.contains(MaterialState.pressed)) {
            return color.background.withOpacity(0.4);
          }
          return null;
        })),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isLanguage
                  ? Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: SvgPicture.asset(
                        flag!,
                        width: 32.0,
                        height: 24.0,
                      ),
                    )
                  : const Center(),
              Text(
                text,
                style: currentTextTheme(context).bodyLarge?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: color.dark100,
                      fontSize: isSelected ? 16.0 : 14.0,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
