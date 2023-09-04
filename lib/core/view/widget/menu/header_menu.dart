import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:talkios/core/view/base/base_stateless.dart';

class HeaderMenu extends BaseStateless {
  const HeaderMenu({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Material(
              type: MaterialType.transparency,
              child: IconButton(
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  back(context);
                },
                icon: Icon(icon.arrowBack),
              ),
            ),
            spacer(width: 14.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Movie Theater",
                  style: currentTextTheme(context).bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: color.dark100,
                        fontSize: 18.0,
                        fontFamily: font.semiBold,
                      ),
                ),
                spacer(height: 2.0),
                Text(
                  "Level 1",
                  style: currentTextTheme(context).bodyLarge?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: color.dark40,
                        fontSize: 12.0,
                        fontFamily: font.regular,
                      ),
                )
              ],
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(icon.star),
            spacer(width: 8.0),
            Text(
              "957",
              style: currentTextTheme(context).bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color.dark100,
                    fontSize: 20.0,
                    fontFamily: font.semiBold,
                  ),
            )
          ],
        )
      ],
    );
  }
}
