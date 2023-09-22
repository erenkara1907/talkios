// ignore_for_file: use_build_context_synchronously, deprecated_member_use, non_constant_identifier_names, must_be_immutable

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/product/conversation/view/conversation_room_view.dart';
import 'package:talkios/product/vocabulary/vocabulary_view_model.dart';

import '../../core/util/provider/sound/dubbing_provider.dart';
import '../../core/util/provider/sound/speech_provider.dart';
import '../home/model/scenario_model.dart';

class VocabularyView extends BaseStateless {
  final int conversationId;
  final String userProfilePhoto;
  final String aiProfilePhoto;
  final List<Word> words;
  final String scenarioName;
  final String level;
  final int score;
  const VocabularyView({
    super.key,
    required this.conversationId,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              spacer(height: 56.0),
              headerMenu(context),
              SizedBox(
                width: width(context: context, value: 1.0),
                height: height(context: context, value: 0.60),
                child: CardSwiper(
                  controller:
                      context.read<VocabularyViewModel>().cardSwiperController,
                  onEnd: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => ConversationRoomView(
                          score: context.read<VocabularyViewModel>().newScore,
                          scenarioName: scenarioName,
                          conversationId: conversationId,
                          userProfilePhoto: userProfilePhoto,
                          aiProfilePhoto: aiProfilePhoto,
                        ),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  isLoop: false,
                  onSwipe: (_, index, CardSwiperDirection) {
                    if (index != null) {
                      context.read<VocabularyViewModel>().cardIndex(index);
                    }
                    return true;
                  },
                  cardsCount: words.length,
                  cardBuilder:
                      (context, index, percentThresholdX, percentThresholdY) {
                    return Material(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(20.0),
                      color: color.background,
                      child: Container(
                        decoration: BoxDecoration(
                          color: color.background,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(19.0),
                              child: Container(
                                width: width(context: context, value: 1.0),
                                height: height(context: context, value: 0.40),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        words[index].image!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            spacer(height: 23.0),
                            Text(
                              words[index].title!,
                              style:
                                  currentTextTheme(context).bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: color.dark100,
                                        fontSize: 20.0,
                                        fontFamily: font.regular,
                                      ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              spacer(height: 55.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 19.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    vocabularyButton(
                      context,
                      icon: icon.sound,
                    ),
                    Consumer<VocabularyViewModel>(
                      builder: (context, state, child) {
                        return AnimatedOpacity(
                          opacity: state.score.isNotEmpty || state.isRecord
                              ? 1.0
                              : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: !state.isRecord
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      state.score,
                                      style: currentTextTheme(context)
                                          .bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: color.dark100,
                                            fontSize: 32.0,
                                            fontFamily: font.regular,
                                          ),
                                    ),
                                    spacer(width: 10.0),
                                    SvgPicture.asset(
                                      icon.star,
                                      width: 32.0,
                                      height: 32.0,
                                    ),
                                  ],
                                )
                              : Center(
                                  child: Lottie.asset(lottie.loadingMessage,
                                      width: 32.0,
                                      height: 32.0,
                                      fit: BoxFit.cover),
                                ),
                        );
                      },
                    ),
                    soundRecordButton(
                      context,
                      icon: icon.microphone,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row headerMenu(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Material(
              type: MaterialType.transparency,
              child: IconButton(
                iconSize: 32.0,
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => ConversationRoomView(
                        score: context.read<VocabularyViewModel>().newScore,
                        scenarioName: scenarioName,
                        conversationId: conversationId,
                        userProfilePhoto: userProfilePhoto,
                        aiProfilePhoto: aiProfilePhoto,
                      ),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                icon: SvgPicture.asset(
                  icon.close,
                  width: 32.0,
                  height: 32.0,
                ),
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
                  "Level $level",
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
            Selector<VocabularyViewModel, int>(
              builder: (context, newScore, child) {
                return Text(
                  newScore == 0 ? score.toString() : newScore.toString(),
                  style: currentTextTheme(context).bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: color.dark100,
                        fontSize: 20.0,
                        fontFamily: font.semiBold,
                      ),
                );
              },
              selector: (context, state) => state.newScore,
            ),
          ],
        )
      ],
    );
  }

  SizedBox vocabularyButton(
    BuildContext context, {
    required String icon,
  }) {
    return SizedBox(
      width: 73.0,
      height: 73.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: color.background,
          shape: CircleBorder(
            side: BorderSide(
              color: color.dark10,
              width: 1.0,
            ),
          ),
        ),
        onPressed: () {
          int index = context.read<VocabularyViewModel>().currentCardIndex;
          context.read<DubbingProvider>().speak(words[index].title!, index);
        },
        child: Center(
          child: SvgPicture.asset(icon),
        ),
      ),
    );
  }

  GestureDetector soundRecordButton(
    BuildContext context, {
    required String icon,
  }) {
    return GestureDetector(
      onLongPressStart: (_) async {
        context.read<DubbingProvider>().stop();
        HapticFeedback.heavyImpact();
        context.read<VocabularyViewModel>().record();
        context.read<VocabularyViewModel>().glowAnimate();
        await context.read<SpeechProvider>().startListening();
        context.read<VocabularyViewModel>().voiceMessage =
            context.read<SpeechProvider>().lastWords;

        await context.read<VocabularyViewModel>().startRecording();
      },
      onLongPressEnd: (_) async {
        int index = context.read<VocabularyViewModel>().currentCardIndex;
        context.read<SpeechProvider>().stopListening();
        context.read<VocabularyViewModel>().glowAnimate();

        await context.read<VocabularyViewModel>().stopRecording(
              context,
              words[index].title!,
              words[index].id!.toString(),
            );

        context.read<DubbingProvider>().stop();
        HapticFeedback.heavyImpact();
      },
      child: Selector<VocabularyViewModel, bool>(
        builder: (context, isGlow, child) {
          return AvatarGlow(
            endRadius: 45.0,
            glowColor: color.dark20,
            animate: isGlow,
            duration: const Duration(milliseconds: 500),
            repeat: true,
            repeatPauseDuration: const Duration(milliseconds: 100),
            showTwoGlows: true,
            curve: Curves.fastOutSlowIn,
            child: Container(
              padding: const EdgeInsets.all(1.0),
              decoration:
                  BoxDecoration(color: color.dark10, shape: BoxShape.circle),
              child: CircleAvatar(
                radius: 35.0,
                backgroundColor: color.background,
                child: SvgPicture.asset(
                  icon,
                  width: 35.0,
                  height: 35.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
        selector: (context, state) => state.isGlowAnimate,
      ),
    );
  }
}
