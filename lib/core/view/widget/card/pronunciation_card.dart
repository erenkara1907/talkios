// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/util/provider/chat_tools_provider.dart';
import 'package:talkios/product/conversation/viewmodel/conversation_room_view_model.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../product/conversation/model/chat_model.dart';
import '../../../util/provider/sound/dubbing_provider.dart';
import '../../../util/provider/sound/speech_provider.dart';
import '../../base/base_state.dart';
import '../button/sound_button.dart';
import '../progress/circle_bubble_progress.dart';

class PronunciationCard extends StatefulWidget {
  ChatModel model;
  int index;
  String message;
  DubbingProvider dubbingProvider;
  String aiProfilePhoto;
  String userProfilePhoto;
  ConversationRoomViewModel viewModel;
  AudioPlayer player;
  String gender;
  int conversationId;
  int messageId;
  List<ChatModel> chats;
  PronunciationCard({
    Key? key,
    required this.model,
    required this.index,
    required this.message,
    required this.dubbingProvider,
    required this.aiProfilePhoto,
    required this.userProfilePhoto,
    required this.viewModel,
    required this.player,
    required this.gender,
    required this.conversationId,
    required this.messageId,
    required this.chats,
  }) : super(key: key);

  @override
  State<PronunciationCard> createState() => _PronunciationCardState();
}

class _PronunciationCardState extends BaseState<PronunciationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width(0.7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: const Color.fromRGBO(157, 157, 233, 0.1),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                spacer(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          widget.model.score == null || widget.model.score == 0
                              ? FutureBuilder(
                                  future: context
                                      .read<ConversationRoomViewModel>()
                                      .pronunciationCheckAPI(
                                        true,
                                        widget.conversationId,
                                        widget.messageId,
                                        context,
                                        widget.message,
                                        widget.model.sound ??
                                            context
                                                .read<
                                                    ConversationRoomViewModel>()
                                                .soundUrl,
                                        widget.chats,
                                      ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          AnimatedOpacity(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            opacity: 0.3,
                                            child: CircleBubbleProgress(
                                              score: "0",
                                              lineWidth: 2.0,
                                              viewModel: widget.viewModel,
                                              circleRadius: 17.0,
                                              textFontSize: 13.0,
                                            ),
                                          ),
                                          Lottie.asset(
                                            lottie.loadingMessage,
                                            width: 42.0,
                                            height: 42.0,
                                          )
                                        ],
                                      );
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return CircleBubbleProgress(
                                        // score: context
                                        //         .read<
                                        //             ConversationRoomViewModel>()
                                        //         .score
                                        //         .isEmpty
                                        //     ? widget.model.score.toString()
                                        //     : context
                                        //         .read<
                                        //             ConversationRoomViewModel>()
                                        //         .score
                                        //         .toString(),
                                        // score: displayedScore,
                                        // score: widget.viewModel.score.isEmpty
                                        //     ? "0"
                                        //     : widget.viewModel.score,
                                        score: context
                                                .read<
                                                    ConversationRoomViewModel>()
                                                .score
                                                .isEmpty
                                            ? "0"
                                            : context
                                                .read<
                                                    ConversationRoomViewModel>()
                                                .score,
                                        lineWidth: 2.0,
                                        viewModel: widget.viewModel,
                                        circleRadius: 17.0,
                                        textFontSize: 13.0,
                                      );
                                    } else {
                                      return const Text("Error");
                                    }
                                  })
                              : Selector<ConversationRoomViewModel, bool>(
                                  builder: (ctx, isLoading, child) {
                                    return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Selector<ConversationRoomViewModel,
                                            String>(
                                          builder: (ctx, newScore, child) {
                                            if (newScore.isNotEmpty &&
                                                int.parse(newScore) >
                                                    widget.model.score!) {
                                              widget.model.score =
                                                  int.parse(newScore);
                                            }
                                            return AnimatedOpacity(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              opacity: isLoading ? 0.3 : 1.0,
                                              child: CircleBubbleProgress(
                                                score: widget.model.score !=
                                                            null &&
                                                        widget.model.score != 0
                                                    ? widget.model.score
                                                        .toString()
                                                    : "0",
                                                lineWidth: 2.0,
                                                viewModel: widget.viewModel,
                                                circleRadius: 17.0,
                                                textFontSize: 13.0,
                                              ),
                                            );
                                          },
                                          selector: (context, state) =>
                                              state.score,
                                        ),
                                        isLoading
                                            ? Lottie.asset(
                                                lottie.loadingMessage,
                                                width: 42.0,
                                                height: 42.0,
                                              )
                                            : const Center(),
                                      ],
                                    );
                                  },
                                  selector: (context, state) =>
                                      state.isPracticeLoading,
                                ),
                          Selector<ConversationRoomViewModel, String>(
                            builder: (context, score, child) {
                              return Text(
                                context
                                    .read<ConversationRoomViewModel>()
                                    .getScoreStatus(
                                      widget.model.score != null &&
                                              widget.model.score != 0
                                          ? int.parse(
                                              widget.model.score.toString())
                                          : score.isEmpty
                                              ? 0
                                              : int.parse(score),
                                    ),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: context
                                      .read<ConversationRoomViewModel>()
                                      .getScoreColor(
                                        widget.model.score != null &&
                                                widget.model.score != 0
                                            ? int.parse(
                                                widget.model.score.toString())
                                            : score.isEmpty
                                                ? 0
                                                : int.parse(score),
                                      ),
                                  fontSize: 20.0,
                                  fontFamily: font.semiBold,
                                ),
                                textAlign: TextAlign.center,
                              );
                            },
                            selector: (context, state) => state.score,
                          ),
                        ],
                      ),
                    ),
                    spacer(width: 35.0),
                    Expanded(
                      child: Column(
                        children: [
                          Selector<ConversationRoomViewModel, bool>(
                            builder: (context, isAI, child) {
                              return SoundButton(
                                borderColor: isAI
                                    ? color.background
                                    : Colors.transparent,
                                onPressed: () async {
                                  await widget.player.stop();
                                  context
                                      .read<ConversationRoomViewModel>()
                                      .tapAIVoice();
                                  widget.dubbingProvider.speak(
                                    widget.message,
                                    widget.index,
                                  );
                                },
                                profilePhoto: icon.appIcon,
                              );
                            },
                            selector: (context, state) => state.isTapAIVoice,
                          ),
                          spacer(height: 10.0),
                          Selector<ConversationRoomViewModel, bool>(
                            builder: (context, isUser, child) {
                              return SoundButton(
                                borderColor: isUser
                                    ? color.background
                                    : Colors.transparent,
                                onPressed: () async {
                                  widget.dubbingProvider.stop();
                                  context
                                      .read<ConversationRoomViewModel>()
                                      .tapUserVoice();
                                  await widget.player.play(UrlSource(
                                      widget.model.sound ??
                                          context
                                              .read<ConversationRoomViewModel>()
                                              .soundUrl));
                                },
                                profilePhoto: widget.userProfilePhoto,
                              );
                            },
                            selector: (context, state) => state.isTapUserVoice,
                          ),
                        ],
                      ),
                    ),
                    spacer(width: 35.0),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Practice",
                            style: currentTextTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(153, 187, 246, 1),
                              fontSize: 14.0,
                              fontFamily: font.regular,
                            ),
                          ),
                          spacer(height: 17.0),
                          GestureDetector(
                            onTap: () async {
                              context.read<DubbingProvider>().stop();
                              Provider.of<SpeechProvider>(context,
                                      listen: false)
                                  .getPermissionAndStartListening(context);
                              if (!context
                                  .read<ConversationRoomViewModel>()
                                  .isPracticeRecord) {
                                context
                                    .read<ConversationRoomViewModel>()
                                    .isPracticeRecord = true;

                                HapticFeedback.heavyImpact();
                                await widget.player
                                    .play(AssetSource(sound.voiceButton));

                                Provider.of<SpeechProvider>(context,
                                        listen: false)
                                    .startListening();
                                await context
                                    .read<ConversationRoomViewModel>()
                                    .startRecording();
                                context
                                    .read<ConversationRoomViewModel>()
                                    .practiceLoading();
                              } else {
                                context
                                    .read<ConversationRoomViewModel>()
                                    .isPracticeRecord = false;
                                //  context
                                // .read<ConversationRoomViewModel>()
                                // .practiceLoading();
                                Provider.of<SpeechProvider>(context,
                                        listen: false)
                                    .stopListening();

                                await context
                                    .read<ConversationRoomViewModel>()
                                    .stopRecording();
                                if (context
                                        .read<SpeechProvider>()
                                        .lastWords
                                        .isEmpty ||
                                    context
                                        .read<ConversationRoomViewModel>()
                                        .path
                                        .isEmpty) {
                                  showTopSnackBar(
                                    Overlay.of(context),
                                    const CustomSnackBar.error(
                                      message: "Please record audio",
                                    ),
                                  );
                                } else {
                                  await context
                                      .read<ConversationRoomViewModel>()
                                      .pronunciationCheck(
                                        false,
                                        widget.conversationId,
                                        widget.messageId,
                                        context,
                                        widget.message,
                                        context
                                            .read<ConversationRoomViewModel>()
                                            .path,
                                        widget.chats,
                                      );
                                }
                              }
                            },
                            // onTap: () async {
                            //   widget.dubbingProvider.stop();
                            //   context.read<DubbingProvider>().stop();
                            //   await widget.player
                            //       .play(AssetSource(sound.voiceButton));
                            //   context
                            //       .read<ConversationRoomViewModel>()
                            //       .showWarning();
                            //   Provider.of<SpeechProvider>(context,
                            //           listen: false)
                            //       .getPermissionAndStartListening(context);
                            // },
                            // onLongPress: () async {
                            //   HapticFeedback.heavyImpact();
                            //   await widget.player
                            //       .play(AssetSource(sound.voiceButton));
                            //   context
                            //       .read<ConversationRoomViewModel>()
                            //       .practiceRecord();
                            //   Provider.of<SpeechProvider>(context,
                            //           listen: false)
                            //       .startListening();
                            //   await context
                            //       .read<ConversationRoomViewModel>()
                            //       .startRecording();
                            //   await widget.player
                            //       .play(AssetSource(sound.voiceButton));
                            // },
                            // onLongPressEnd: (_) async {
                            //   context
                            //       .read<ConversationRoomViewModel>()
                            //       .practiceRecord();
                            //   Provider.of<SpeechProvider>(context,
                            //           listen: false)
                            //       .stopListening();

                            //   await context
                            //       .read<ConversationRoomViewModel>()
                            //       .stopRecording();
                            //   context
                            //       .read<ConversationRoomViewModel>()
                            //       .practiceLoading();
                            //   await context
                            //       .read<ConversationRoomViewModel>()
                            //       .pronunciationCheck(
                            //         false,
                            //         widget.conversationId,
                            //         widget.messageId,
                            //         context,
                            //         widget.message,
                            //         context
                            //             .read<ConversationRoomViewModel>()
                            //             .path,
                            //         widget.chats,
                            //       );
                            //   context
                            //       .read<ConversationRoomViewModel>()
                            //       .practiceLoading();

                            //   HapticFeedback.heavyImpact();
                            // },
                            child: Selector<ConversationRoomViewModel, bool>(
                              builder: (ctx, isPractice, child) {
                                return SvgPicture.asset(
                                  icon.microphone,
                                  color: isPractice
                                      ? color.background
                                      : const Color.fromRGBO(47, 67, 141, 1),
                                );
                              },
                              selector: (context, state) =>
                                  state.isPracticeRecord,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                spacer(height: 10.0),
              ],
            ),
          ),
          Positioned(
            top: 0.0,
            right: 0.0,
            child: IconButton(
              onPressed: () {
                context.read<ChatToolsProvider>().isPronunciation = false;
              },
              icon: const Icon(
                Icons.close,
                size: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
