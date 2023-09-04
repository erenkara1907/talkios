import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:talkios/core/view/base/base_stateless.dart';

class AccountButton extends BaseStateless {
  final String label;
  final String? text;
  final void Function() onPressed;
  final bool? isAvailableCheckbox;
  const AccountButton({
    super.key,
    required this.label,
    this.text,
    required this.onPressed,
    this.isAvailableCheckbox = false,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: color.background,
        shadowColor: Colors.transparent,
      ).copyWith(
          overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
        if (states.contains(MaterialState.pressed)) {
          return Colors.transparent;
        }
        return null;
      })),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: currentTextTheme(context).bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: color.dark100,
                  fontSize: 14.0,
                  fontFamily: font.medium),
            ),
            isAvailableCheckbox!
                ? SizedBox(
                    width: 30.0,
                    height: 10.0,
                    child: Transform.scale(
                      scale: 0.7,
                      child: CupertinoSwitch(
                        value: true,
                        onChanged: (_) {},
                        activeColor: color.cyan,
                      ),
                    ),
                  )
                : Text(
                    text ?? "",
                    style: currentTextTheme(context).bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: color.cyan,
                          fontSize: 14.0,
                          fontFamily: font.medium,
                        ),
                  )
          ],
        ),
      ),
    );
  }
}
