import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:talkios/core/view/base/base_stateless.dart';

class ProfileButton extends BaseStateless {
  final String text;
  final void Function() onPressed;
  final String profileIcon;
  final bool isLogout;
  final Color? backgroundColor;
  final double? rightPosition;

  const ProfileButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.profileIcon,
    this.isLogout = false,
    this.backgroundColor,
    this.rightPosition = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: backgroundColor ?? Colors.transparent,
        foregroundColor: color.background,
        shadowColor: Colors.transparent,
      ).copyWith(
          overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
        if (states.contains(MaterialState.pressed)) {
          return color.dark10;
        }
        return null;
      })),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                isLogout
                    ? const Icon(
                        Icons.close,
                        color: Colors.red,
                      )
                    : SvgPicture.asset(profileIcon),
                spacer(width: 22.0),
                Text(
                  text,
                  style: currentTextTheme(context).bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isLogout ? Colors.red : color.dark100,
                        fontSize: 14.0,
                        fontFamily: font.medium,
                      ),
                )
              ],
            ),
            isLogout
                ? const Center()
                : InkWell(
                    onTap: onPressed,
                    child: Icon(
                      icon.arrowForward,
                      color: color.dark100,
                      size: 16.0,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
