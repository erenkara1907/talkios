import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/product/conversation/view/conversation_view.dart';
import 'package:talkios/product/home/view/home_view.dart';

import '../../../util/provider/sound/dubbing_provider.dart';

class HeaderMenu extends BaseStateless {
  final String userProfilePhoto;
  final String scenarioName;
  final int score;
  final String fromWhere;
  final DubbingProvider dubbingProvider;

  const HeaderMenu({
    super.key,
    required this.userProfilePhoto,
    required this.scenarioName,
    required this.score,
    required this.fromWhere,
    required this.dubbingProvider,
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
                  dubbingProvider.stop();
                  HapticFeedback.heavyImpact();
                  if (fromWhere == "detail") {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => HomeView(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  } else {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => ConversationView(
                          score: score,
                          userProfilePhoto: userProfilePhoto,
                        ),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  }
                },
                icon: Icon(icon.arrowBack),
              ),
            ),
            spacer(width: 14.0),
            Text(
              scenarioName,
              style: currentTextTheme(context).bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color.dark100,
                    fontSize: 18.0,
                    fontFamily: font.semiBold,
                  ),
            ),
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
