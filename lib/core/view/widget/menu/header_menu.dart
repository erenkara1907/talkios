import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/product/conversation/view/conversation_view.dart';

import '../../../util/provider/sound/dubbing_provider.dart';

class HeaderMenu extends BaseStateless {
  final String userProfilePhoto;
  final String scenarioName;
  final int score;
  const HeaderMenu({
    super.key,
    required this.userProfilePhoto,
    required this.scenarioName,
    required this.score,
  });
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
                  context.read<DubbingProvider>().stop();
                  HapticFeedback.heavyImpact();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => ConversationView(
                        score: score,
                        userProfilePhoto: userProfilePhoto,
                      ),
                    ),
                    (Route<dynamic> route) => false,
                  );
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
                  scenarioName,
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
              score.toString(),
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
