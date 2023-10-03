// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/core/view/widget/button/app_button.dart';
import 'package:talkios/product/conversation/view/conversation_room_view.dart';
import 'package:talkios/product/home/home_view_model.dart';
import 'package:talkios/product/vocabulary/view/vocabulary_view.dart';
import 'package:talkios/product/vocabulary/vocabulary_view_model.dart';

import '../../../core/constant/config_constant.dart';
import '../model/scenario_model.dart';

class ScenarioDetailView extends BaseStateless {
  final String subTitle;
  final String scenarioDescription;
  final String tagId;
  final int scenarioId;
  final String userProfilePhoto;
  final String aiProfilePhoto;
  final List<Word> words;
  final String scenarioName;
  final String level;
  final int score;
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
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            image.background,
            fit: BoxFit.cover,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: width(context: context, value: 1.0),
                  height: height(context: context, value: 0.4),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0),
                    ),
                    child: Hero(
                      tag: tagId,
                      child: CachedNetworkImage(
                        imageUrl:
                            aiProfilePhoto, // Buraya resmin URL'sini ekleyin.
                        fit: BoxFit
                            .cover, // BoxFit.fill, BoxFit.contain gibi farklı seçenekler de mevcut.
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0.0,
                  top: 50.0,
                  child: Material(
                    type: MaterialType.transparency,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: IconButton(
                        iconSize: 36.0,
                        onPressed: () {
                          HapticFeedback.heavyImpact();
                          back(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          size: 36.0,
                        ),
                        color: color.background,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Expanded(child: SizedBox()),
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
            Selector<HomeViewModel, bool>(
              builder: (context, isTapVocabulary, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: isTapVocabulary ? 0.3 : 1.0,
                      child: AbsorbPointer(
                        absorbing: isTapVocabulary,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color.background,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(
                                  color: Color.fromRGBO(243, 243, 245, 1),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              context.read<HomeViewModel>().tapVocabulary();
                              analyticInstance.logEvent(
                                  name: 'start_vocabulary');
                              if (context
                                      .read<VocabularyViewModel>()
                                      .newScore !=
                                  0) {
                                context
                                    .read<VocabularyViewModel>()
                                    .defaultNewScore(context
                                        .read<VocabularyViewModel>()
                                        .newScore);
                              } else {
                                context
                                    .read<VocabularyViewModel>()
                                    .defaultNewScore(score);
                              }
                              if (context
                                      .read<HomeViewModel>()
                                      .conversationId !=
                                  -1) {
                                push(
                                  context,
                                  VocabularyView(
                                    conversationId: context
                                        .read<HomeViewModel>()
                                        .conversationId,
                                    userProfilePhoto: userProfilePhoto,
                                    aiProfilePhoto: aiProfilePhoto,
                                    words: words,
                                    scenarioName: scenarioName,
                                    level: level,
                                  ),
                                );
                              } else {
                                context
                                    .read<VocabularyViewModel>()
                                    .removeScore();
                                await context
                                    .read<HomeViewModel>()
                                    .storeConversation(
                                      context,
                                      scenarioId.toString(),
                                      aiProfilePhoto,
                                      userProfilePhoto,
                                      words,
                                      scenarioName,
                                      level,
                                      score,
                                      true,
                                    );
                              }
                              context.read<HomeViewModel>().tapVocabulary();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(icon.card),
                                  spacer(width: 14.0),
                                  Expanded(
                                    flex: 5,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Vocabulary",
                                          style: currentTextTheme(context)
                                              .bodyLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: color.dark80,
                                                fontSize: 16.0,
                                                fontFamily: font.medium,
                                              ),
                                        ),
                                        spacer(height: 4.0),
                                        Text(
                                          "Prepare for conversations by learning some new words.",
                                          style: currentTextTheme(context)
                                              .bodyLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: color.dark40,
                                                fontSize: 12.0,
                                                fontFamily: font.regular,
                                              ),
                                          overflow: TextOverflow.clip,
                                          maxLines: 2,
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    iconSize: 20.0,
                                    onPressed: () async {
                                      context
                                          .read<HomeViewModel>()
                                          .tapVocabulary();
                                      analyticInstance.logEvent(
                                          name: 'start_vocabulary');
                                      context
                                          .read<VocabularyViewModel>()
                                          .defaultNewScore(score);
                                      if (context
                                              .read<HomeViewModel>()
                                              .conversationId !=
                                          -1) {
                                        push(
                                          context,
                                          VocabularyView(
                                            conversationId: context
                                                .read<HomeViewModel>()
                                                .conversationId,
                                            userProfilePhoto: userProfilePhoto,
                                            aiProfilePhoto: aiProfilePhoto,
                                            words: words,
                                            scenarioName: scenarioName,
                                            level: level,
                                          ),
                                        );
                                      } else {
                                        await context
                                            .read<HomeViewModel>()
                                            .storeConversation(
                                              context,
                                              scenarioId.toString(),
                                              aiProfilePhoto,
                                              userProfilePhoto,
                                              words,
                                              scenarioName,
                                              level,
                                              score,
                                              true,
                                            );
                                      }
                                      context
                                          .read<HomeViewModel>()
                                          .tapVocabulary();
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      color: color.dark100,
                                      size: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: isTapVocabulary ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: CircularProgressIndicator(
                        color: color.dark100,
                        strokeWidth: 1.0,
                      ),
                    ),
                  ],
                );
              },
              selector: (context, state) => state.isTapVocabulary,
            ),
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
                    text: "Start the Conversation",
                    borderRadius: 66.0,
                    isLoading: isTap,
                    backgroundColor: color.dark100,
                    onPressed: () async {
                      if (context.read<HomeViewModel>().conversationId != -1) {
                        push(
                          context,
                          ConversationRoomView(
                            fromWhere: "detail",
                            conversationId:
                                context.read<HomeViewModel>().conversationId,
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
      ],
    );
  }
}
