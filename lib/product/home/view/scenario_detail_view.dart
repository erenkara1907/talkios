// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/core/view/widget/button/app_button.dart';
import 'package:talkios/product/conversation/view/conversation_room_view.dart';
import 'package:talkios/product/home/home_view_model.dart';

import '../../../core/constant/config_constant.dart';
import '../model/scenario_model.dart';

class ScenarioDetailView extends BaseStateless {
  final String subTitle;
  final String scenarioDescription;
  final String tagId;
  final int scenarioId;
  final String userProfilePhoto;
  final String aiProfilePhoto;
  final List<WordScenario> words;
  final String scenarioName;
  final String level;
  final int score;
  final bool isConversation;
  final int conversationId;
  final int isActive;
  final String gender;
  final Color colorValue;
  const ScenarioDetailView({
    super.key,
    required this.subTitle,
    required this.scenarioDescription,
    required this.tagId,
    required this.scenarioId,
    required this.userProfilePhoto,
    required this.aiProfilePhoto,
    required this.words,
    required this.scenarioName,
    required this.level,
    required this.score,
    required this.isConversation,
    required this.conversationId,
    required this.isActive,
    required this.gender,
    required this.colorValue,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
            child: Container(
          color: color.background,
        )),
        Container(
          color: colorValue.withOpacity(0.4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Material(
                  type: MaterialType.transparency,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 14.0,
                      top: 56.0,
                    ),
                    child: IconButton(
                      iconSize: 36.0,
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        back(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 28.0,
                      ),
                      color: color.dark100,
                    ),
                  ),
                ),
              ),
              Hero(
                tag: tagId,
                child: SvgPicture.network(
                  aiProfilePhoto,
                  width: 251.0,
                  height: 198.0,
                ),
              ),
              const Expanded(child: SizedBox()),
              spacer(height: 30.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  subTitle,
                  style: currentTextTheme(context).bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: color.dark100,
                        fontSize: 24.0,
                        fontFamily: font.semiBold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              spacer(height: 5.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  scenarioDescription,
                  style: currentTextTheme(context).bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: color.dark50,
                        fontSize: 14.0,
                        fontFamily: font.medium,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Expanded(child: SizedBox()),
              taskInfo(context,
                  icon: icon.taskDetail, text: "Complete the tasks."),
              taskInfo(context,
                  icon: icon.translateDetail,
                  text: "You can translate message."),
              taskInfo(context, icon: icon.tip, text: "Use the tips"),
              const Expanded(flex: 3, child: SizedBox()),
              Selector<HomeViewModel, bool>(
                builder: (context, isTap, child) {
                  return AnimatedPadding(
                    duration: const Duration(milliseconds: 300),
                    padding:
                        EdgeInsets.symmetric(horizontal: isTap ? 74.0 : 34.0),
                    child: AppButton(
                      widthValue: width(context: context, value: 1.0),
                      heightValue: height(context: context, value: 0.06),
                      text: isConversation == true && conversationId != 0
                          ? "Continue to Chat"
                          : "Start the Conversation",
                      borderRadius: 66.0,
                      isLoading: isTap,
                      backgroundColor: color.dark100,
                      onPressed: () async {
                        if (isConversation == true && (conversationId != 0)) {
                          push(
                            context,
                            ConversationRoomView(
                              isActive: isActive,
                              gender: gender,
                              fromWhere: "detail",
                              conversationId: conversationId,
                              userProfilePhoto: userProfilePhoto,
                              aiProfilePhoto: aiProfilePhoto,
                              scenarioName: scenarioName,
                              score: score,
                            ),
                          );
                        } else {
                          analyticInstance.logEvent(name: 'start_conversation');
                          context.read<HomeViewModel>().tapButton();

                          await context.read<HomeViewModel>().storeConversation(
                                context,
                                scenarioId.toString(),
                                aiProfilePhoto,
                                userProfilePhoto,
                                words,
                                scenarioName,
                                level,
                                score,
                                false,
                                gender,
                              );
                          context.read<HomeViewModel>().tapButton();
                        }
                      },
                      textStyle: currentTextTheme(context).bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: color.background,
                            fontSize: 14.0,
                            fontFamily: font.bold,
                          ),
                    ),
                  );
                },
                selector: (context, state) => state.isTap,
              ),
              spacer(height: 11.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "You are talking to an artificial intelligence, not a human.",
                    style: currentTextTheme(context).bodyLarge?.copyWith(
                          fontWeight: FontWeight.w300,
                          color: color.dark40,
                          fontSize: 10.0,
                          fontFamily: font.light,
                        ),
                  ),
                ),
              ),
              spacer(height: 40.0),
            ],
          ),
        ),
      ],
    );
  }

  Expanded taskInfo(BuildContext context,
      {required String icon, required String text}) {
    return Expanded(
      child: SizedBox(
        width: width(context: context, value: 1.0) * 0.6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(icon, width: 16.5, height: 16.5),
            spacer(width: 18.5),
            Text(
              text,
              style: currentTextTheme(context).bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: color.dark80,
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
