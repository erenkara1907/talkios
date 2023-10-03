import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/core/view/widget/button/app_button.dart';
import 'package:talkios/product/conversation/view/conversation_room_view.dart';
import 'package:talkios/product/home/view/home_view.dart';

import '../../../core/constant/config_constant.dart';

class StartChatView extends BaseStateless {
  final int conversationId;
  final String userProfilePhoto;
  final String aiProfilePhoto;
  final String scenarioName;
  final int score;
  const StartChatView({
    super.key,
    required this.conversationId,
    required this.userProfilePhoto,
    required this.aiProfilePhoto,
    required this.scenarioName,
    required this.score,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              image.background,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              spacer(height: 56.0),
              Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    iconSize: 32.0,
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => HomeView()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    icon: SvgPicture.asset(
                      icon.close,
                      color: color.dark100,
                      width: 32.0,
                      height: 32.0,
                    ),
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
              Text(
                "Let’s Chat 🎉",
                style: currentTextTheme(context).bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: color.dark100,
                      fontFamily: font.semiBold,
                      fontSize: 24.0,
                    ),
              ),
              spacer(height: 5.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Text(
                  "You have completed the word cards. Now you can star speaking to practice.",
                  style: currentTextTheme(context).bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: color.dark50,
                        fontSize: 14.0,
                        fontFamily: font.medium,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              spacer(height: 15.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SvgPicture.asset(icon.kite),
              ),
              const Expanded(flex: 2, child: SizedBox()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                child: AppButton(
                  widthValue: width(context: context, value: 1.0),
                  heightValue: height(context: context, value: 0.07),
                  text: "Start the Conversation",
                  textStyle: currentTextTheme(context).bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: color.background,
                        fontSize: 14.0,
                        fontFamily: font.bold,
                      ),
                  borderRadius: 66.0,
                  backgroundColor: color.dark100,
                  onPressed: () {
                    analyticInstance.logEvent(name: 'start_conversation');
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => ConversationRoomView(
                          fromWhere: "detail",
                          score: score,
                          scenarioName: scenarioName,
                          conversationId: conversationId,
                          userProfilePhoto: userProfilePhoto,
                          aiProfilePhoto: aiProfilePhoto,
                        ),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ),
              spacer(height: 10.0),
              Text(
                "You are talking to an artificial intelligence, not a human.",
                style: currentTextTheme(context).bodyLarge?.copyWith(
                      fontWeight: FontWeight.w300,
                      color: color.dark40,
                      fontSize: 10.0,
                      fontFamily: font.light,
                    ),
                textAlign: TextAlign.center,
              ),
              spacer(height: 33.0),
            ],
          ),
        ],
      ),
    );
  }
}
