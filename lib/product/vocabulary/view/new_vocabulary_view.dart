// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:talkios/product/home/model/scenario_model.dart';
import 'package:talkios/product/vocabulary/vocabulary_view_model.dart';

import '../../../core/util/connectivity_service.dart';
import '../../../core/util/provider/sound/dubbing_provider.dart';
import '../../../core/util/provider/sound/speech_provider.dart';
import '../../../core/util/provider/translate_provider.dart';
import '../../../core/view/base/base_state.dart';
import '../../home/view/new_home_view.dart';

class NewVocabularyView extends StatefulWidget {
  final int conversationId;
  final String userProfilePhoto;
  final String aiProfilePhoto;
  final List<WordScenario> words;
  final String scenarioName;
  final String level;
  final String gender;
  final Color color;
  const NewVocabularyView({
    Key? key,
    required this.conversationId,
    required this.userProfilePhoto,
    required this.aiProfilePhoto,
    required this.words,
    required this.scenarioName,
    required this.level,
    required this.gender,
    required this.color,
  }) : super(key: key);

  @override
  State<NewVocabularyView> createState() => _NewVocabularyViewState();
}

class _NewVocabularyViewState extends BaseState<NewVocabularyView> {
  final TranslateProvider _translateProvider = TranslateProvider();
  @override
  void initState() {
    context.read<SpeechProvider>().initialize();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider.of<ConnectivityService>(context, listen: true)
                .connectionStatus ==
            ConnectionStatus.Online
        ? vocabulary(context)
        : Center(
            child: Lottie.asset(lottie.networkError),
          );
  }

  Scaffold vocabulary(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: width(1.0),
            height: height(1.0),
            color: const Color.fromRGBO(240, 241, 246, 1),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            width: width(1.0),
            height: height(1.0),
            color: widget.color.withOpacity(0.6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                spacer(height: 56.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () async {
                        context.read<VocabularyViewModel>().cardIndex(0);
                        context.read<VocabularyViewModel>().record(false);
                        context.read<VocabularyViewModel>().isScore = false;
                        context.read<VocabularyViewModel>().isLoading = false;
                        // await context.read<VocabularyViewModel>().stopRecord();
                        context.read<SpeechProvider>().stopListening();
                        context.read<SpeechProvider>().lastWords = "";
                        context.read<VocabularyViewModel>().indicatorValue =
                            0.0;
                        context.read<VocabularyViewModel>().completeWordCount =
                            1;
                        context
                            .read<VocabularyViewModel>()
                            .completeWordCountV2 = 0;
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const HomeView()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      icon: Icon(icon.arrowBack),
                    ),
                    Selector<VocabularyViewModel, int>(
                      builder: (ctx, newScore, child) {
                        return headerChip(
                          context,
                          newScore.toString(),
                          icon.star,
                          const Color.fromRGBO(85, 141, 240, 0.3),
                          const Color.fromRGBO(85, 141, 240, 1.0),
                        );
                      },
                      selector: (context, state) => state.newScore,
                    ),
                  ],
                ),
                spacer(height: 32.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Selector<VocabularyViewModel, double>(
                          builder: (ctx, indicatorValue, child) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(54.0),
                              child: LinearProgressIndicator(
                                value: 0.25 + indicatorValue,
                                backgroundColor:
                                    color.background.withOpacity(0.2),
                                color: const Color.fromRGBO(85, 141, 240, 1),
                                minHeight: 6.0,
                              ),
                            );
                          },
                          selector: (context, state) => state.indicatorValue,
                        ),
                      ),
                      spacer(width: 13.0),
                      Selector<VocabularyViewModel, int>(
                        builder: (ctx, completeCount, child) {
                          return Text(
                            "$completeCount/${widget.words.length}",
                            style: currentTextTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0,
                              color: const Color.fromRGBO(153, 187, 246, 1),
                              fontFamily: font.medium,
                            ),
                          );
                        },
                        selector: (context, state) => state.completeWordCount,
                      ),
                    ],
                  ),
                ),
                const Expanded(flex: 2, child: SizedBox()),
                Expanded(
                  flex: 6,
                  child: SizedBox(
                    height: 300.0,
                    child: PageView.builder(
                      controller:
                          context.read<VocabularyViewModel>().pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.words.length,
                      onPageChanged: (int index) {
                        context.read<VocabularyViewModel>().cardIndex(index);
                        context.read<VocabularyViewModel>().isScore = false;
                      },
                      itemBuilder: (context, index) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Consumer<VocabularyViewModel>(
                              builder: (ctx, state, child) {
                                return AnimatedOpacity(
                                  duration: const Duration(milliseconds: 300),
                                  opacity: state.isScore ? 1.0 : 0.0,
                                  child: Column(
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CircularPercentIndicator(
                                            radius: 60.0,
                                            lineWidth: 5.0,
                                            animation: true,
                                            percent: state.score.isNotEmpty
                                                ? double.parse(state.score) /
                                                    100
                                                : 0,
                                            progressColor: const Color.fromRGBO(
                                                85, 141, 240, 1),
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                        85, 141, 240, 1)
                                                    .withOpacity(0.5),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                state.score,
                                                style: currentTextTheme
                                                    .bodyLarge
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 48.0,
                                                  color: const Color.fromRGBO(
                                                      85, 141, 240, 1),
                                                  fontFamily: font.semiBold,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SvgPicture.asset(
                                                    icon.star,
                                                    color: const Color.fromRGBO(
                                                        85, 141, 240, 1),
                                                    width: 16.0,
                                                    height: 16.0,
                                                  ),
                                                  spacer(width: 3.0),
                                                  SvgPicture.asset(
                                                    icon.star,
                                                    color: const Color.fromRGBO(
                                                        85, 141, 240, 1),
                                                    width: 16.0,
                                                    height: 16.0,
                                                  ),
                                                  spacer(width: 3.0),
                                                  SvgPicture.asset(
                                                    icon.star,
                                                    color: const Color.fromRGBO(
                                                        85, 141, 240, 1),
                                                    width: 16.0,
                                                    height: 16.0,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      spacer(height: 12.0),
                                      Text(
                                        "Your pronunciation score",
                                        style: currentTextTheme.bodyLarge
                                            ?.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: color.dark80,
                                          fontSize: 14.0,
                                          fontFamily: font.regular,
                                        ),
                                      ),
                                      Text(
                                        widget.words[index].title!,
                                        style: currentTextTheme.bodyLarge
                                            ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: color.dark100,
                                          fontSize: 20.0,
                                          fontFamily: font.regular,
                                        ),
                                        maxLines: 1,
                                        textAlign: TextAlign
                                            .center, // Metni ortalamak için
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Selector<VocabularyViewModel, bool>(
                              builder: (ctx, isScore, child) {
                                return isScore ? const Center() : word(index);
                              },
                              selector: (context, state) => state.isScore,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                Selector<VocabularyViewModel, bool>(
                  builder: (ctx, isTap, child) {
                    return Stack(
                      children: [
                        voiceSection(context),
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          top: 0.0,
                          left: isTap ? 30.0 : 0.0,
                          child: AnimatedOpacity(
                            opacity: isTap ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              decoration: BoxDecoration(
                                color: color.softBlue,
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Please click the button to start and finish",
                                  style: currentTextTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: color.background,
                                    fontSize: 14.0,
                                    fontFamily: font.regular,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  selector: (context, state) => state.onTapVoiceButton,
                ),
                const Expanded(flex: 2, child: SizedBox()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding voiceSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 37.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Selector<VocabularyViewModel, bool>(
            builder: (ctx, isRecord, child) {
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isRecord ? 0.0 : 1.0,
                child: IconButton(
                  onPressed: () {
                    int index =
                        context.read<VocabularyViewModel>().currentCardIndex;
                    context.read<DubbingProvider>().speak(
                          widget.words[index].title!,
                          index,
                        );
                  },
                  icon: SvgPicture.asset(
                    icon.soundVocabulary,
                    width: 24.0,
                    height: 24.0,
                  ),
                ),
              );
            },
            selector: (context, state) => state.isRecord,
          ),
          Selector<VocabularyViewModel, bool>(
            builder: (ctx, isRecord, child) {
              return Column(
                children: [
                  AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      decoration: BoxDecoration(
                        color: color.dark10,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          isRecord ? "Tap when done" : "Tap to speak",
                          style: currentTextTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w300,
                            color: color.dark40,
                            fontSize: 12.0,
                            fontFamily: font.regular,
                          ),
                        ),
                      ),
                    ),
                  ),
                  spacer(height: isRecord ? 0.0 : 11.0),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      isRecord
                          ? AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: width(0.4),
                              height: 150.0,
                              child: Lottie.asset(lottie.recording),
                            )
                          : const Center(),
                      Container(
                        width: 86.0, // Çemberin çapı (çapın iki katı)
                        height: 86.0, // Çemberin çapı (çapın iki katı)
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color.fromRGBO(85, 141, 240, 1)
                              .withOpacity(isRecord ? 1.0 : 0.2),
                          boxShadow: const [
                            BoxShadow(
                              color:
                                  Color.fromRGBO(0, 0, 0, 0.25), // Gölge rengi
                              blurRadius: 10.0, // Gölge bulanıklığı (yoğunluğu)
                              spreadRadius: 0, // Gölgenin genişlemesi
                              offset: Offset(
                                  0, 8), // Gölgenin yatay ve dikey konumu
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            Provider.of<SpeechProvider>(context, listen: false)
                                .getPermissionAndStartListening(context);
                            context.read<DubbingProvider>().stop();
                            if (!context.read<VocabularyViewModel>().isRecord) {
                              context.read<DubbingProvider>().stop();
                              HapticFeedback.heavyImpact();
                              context.read<VocabularyViewModel>().record(true);
                              await context
                                  .read<SpeechProvider>()
                                  .startListening();
                              context.read<VocabularyViewModel>().voiceMessage =
                                  context.read<SpeechProvider>().lastWords;
                              await context
                                  .read<VocabularyViewModel>()
                                  .startRecording();
                            } else {
                              context.read<VocabularyViewModel>().record(false);
                              context.read<SpeechProvider>().stopListening();
                              int index = context
                                  .read<VocabularyViewModel>()
                                  .currentCardIndex;
                              await context
                                  .read<VocabularyViewModel>()
                                  .stopRecording(
                                    context,
                                    widget.words[index].title!,
                                    widget.words[index].id!.toString(),
                                    widget.conversationId,
                                    widget.words.length,
                                  );
                            }
                          },
                          onLongPress: () {
                            context
                                .read<VocabularyViewModel>()
                                .onTapVoiceButton = true;
                            Future.delayed(
                              const Duration(seconds: 2),
                              () {
                                context
                                    .read<VocabularyViewModel>()
                                    .onTapVoiceButton = false;
                              },
                            );
                          },
                          child: AnimatedContainer(
                            width: 73.0,
                            height: 73.0,
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: isRecord
                                  ? const Color.fromRGBO(85, 141, 240, 1)
                                  : const Color.fromRGBO(205, 223, 255, 1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: color.dark10, // Beyaz kenar rengi
                                width: 1.0, // Kenar kalınlığı
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 6,
                                  offset: const Offset(
                                    0,
                                    3,
                                  ), // Gölgeyi aşağıya doğru vermek için
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 36.5,
                              // backgroundColor:const Color.fromRGBO(205, 223, 255, 1),
                              backgroundColor: Colors.transparent,
                              child: SvgPicture.asset(
                                icon.microphone,
                                fit: BoxFit.fill,
                                color: isRecord
                                    ? color.background
                                    : const Color.fromRGBO(47, 67, 141, 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
            selector: (context, state) => state.isRecord,
          ),
          Selector<VocabularyViewModel, bool>(
            builder: (ctx, isRecord, child) {
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isRecord ? 0.0 : 1.0,
                child: IconButton(
                  onPressed: () {
                    TranslateProvider provider =
                        context.read<TranslateProvider>();
                    if (provider.isTapTranslate) {
                      provider.isTapTranslate = false;
                    } else {
                      provider.isTapTranslate = true;
                    }
                  },
                  icon: SvgPicture.asset(
                    icon.translate,
                    width: 24.0,
                    height: 24.0,
                    color: color.blue,
                  ),
                ),
              );
            },
            selector: (contxt, state) => state.isRecord,
          ),
        ],
      ),
    );
  }

  Widget word(int index) {
    return Selector<VocabularyViewModel, bool>(
        builder: (ctx, isLoading, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isLoading ? 0.4 : 1.0,
                child: wordMethod(index),
              ),
              isLoading
                  ? Lottie.asset(
                      lottie.loadingMessage,
                      width: 100.0,
                      height: 100.0,
                    )
                  : const Center(),
            ],
          );
        },
        selector: (context, state) => state.isLoading);
  }

  Column wordMethod(int index) {
    return Column(
      children: [
        Expanded(
          child: SvgPicture.network(
            widget.words[index].image!,
            width: 251.0,
            height: 198.0,
          ),
        ),
        spacer(height: 25.0),
        Selector<TranslateProvider, bool>(
          builder: (ctx, isTap, child) {
            return isTap
                ? FutureBuilder(
                    future: _translateProvider.translate(
                        text: widget.words[index].title!),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Lottie.asset(lottie.loadingMessage,
                            width: 42.0, height: 42.0);
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        return Text(
                          _translateProvider.translatedText,
                          style: currentTextTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: color.dark100,
                            fontSize: 20.0,
                            fontFamily: font.regular,
                          ),
                          maxLines: 1,
                          textAlign: TextAlign.center, // Metni ortalamak için
                        );
                      } else {
                        return Text(
                          "Please try again",
                          style: currentTextTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: Colors.red,
                            fontSize: 20.0,
                            fontFamily: font.regular,
                          ),
                          maxLines: 1,
                          textAlign: TextAlign.center, // Metni ortalamak için
                        );
                      }
                    },
                  )
                : Text(
                    widget.words[index].title!,
                    style: currentTextTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: color.dark100,
                      fontSize: 20.0,
                      fontFamily: font.regular,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.center, // Metni ortalamak için
                  );
          },
          selector: (context, state) => state.isTapTranslate,
        ),
      ],
    );
  }

  Chip headerChip(
    BuildContext context,
    String text,
    String icon,
    Color backgroundColor,
    Color itemColor,
  ) {
    return Chip(
      padding: const EdgeInsets.all(8.0),
      backgroundColor: backgroundColor,
      avatar: SvgPicture.asset(
        icon,
        color: itemColor,
      ),
      label: Text(
        text,
        style: currentTextTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: itemColor,
          fontSize: 14.0,
          fontFamily: font.extraBold,
        ),
      ),
    );
  }
}
