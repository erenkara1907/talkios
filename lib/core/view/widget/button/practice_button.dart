// ignore_for_file: deprecated_member_use, must_be_immutable, use_build_context_synchronously

import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/product/conversation/model/chat_model.dart';

import '../../../../product/conversation/viewmodel/conversation_room_view_model.dart';
import '../../../util/provider/sound/dubbing_provider.dart';
import '../../../util/provider/sound/speech_provider.dart';

class PracticeButton extends BaseStateless {
  DubbingProvider dubbingProvider;
  String message;
  ConversationRoomViewModel viewModel;
  int conversationId;
  int messageId;
  List<ChatModel> chats;
  PracticeButton({
    super.key,
    required this.dubbingProvider,
    required this.message,
    required this.viewModel,
    required this.conversationId,
    required this.messageId,
    required this.chats,
  });

  AudioPlayer player = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            dubbingProvider.stop();
            context.read<DubbingProvider>().stop();
            await player.play(AssetSource(sound.voiceButton));
            context.read<ConversationRoomViewModel>().showWarning();
            Provider.of<SpeechProvider>(context, listen: false)
                .getPermissionAndStartListening(context);
          },
          onLongPress: () async {
            context.read<ConversationRoomViewModel>().practiceRecord();
            Provider.of<SpeechProvider>(context, listen: false)
                .startListening();
            await context.read<ConversationRoomViewModel>().startRecording();
          },
          onLongPressEnd: (details) async {
            context.read<ConversationRoomViewModel>().practiceRecord();
            Provider.of<SpeechProvider>(context, listen: false).stopListening();

            await context.read<ConversationRoomViewModel>().stopRecording();
            context.read<ConversationRoomViewModel>().practiceLoading();
            await context.read<ConversationRoomViewModel>().pronunciationCheck(
                  false,
                  conversationId,
                  messageId,
                  context,
                  message,
                  context.read<ConversationRoomViewModel>().path,
                  chats,
                );
            context.read<ConversationRoomViewModel>().practiceLoading();
            // if (context.read<ConversationRoomViewModel>().score.isNotEmpty ||
            //     viewModel.score.isNotEmpty) {
            //   await context.read<ConversationRoomViewModel>().updateAPIScore(
            //         conversationId: conversationId,
            //         messageId: messageId,
            //         score: context
            //                 .read<ConversationRoomViewModel>()
            //                 .score
            //                 .isNotEmpty
            //             ? context.read<ConversationRoomViewModel>().score
            //             : viewModel.score,
            //       );
            // }
          },
          child: Selector<ConversationRoomViewModel, bool>(
            builder: (context, isPractice, child) {
              return AvatarGlow(
                endRadius: 75.0,
                glowColor: color.dark20,
                animate: isPractice,
                duration: const Duration(milliseconds: 500),
                repeat: true,
                repeatPauseDuration: const Duration(milliseconds: 100),
                showTwoGlows: true,
                curve: Curves.fastOutSlowIn,
                child: CircleAvatar(
                  radius: 55.0,
                  backgroundColor: const Color.fromRGBO(217, 217, 217, 0.5),
                  child: CircleAvatar(
                    radius: 46.0,
                    backgroundColor: const Color.fromRGBO(217, 217, 217, 0.8),
                    child: CircleAvatar(
                      radius: 43.0,
                      backgroundColor: color.background,
                      child: SvgPicture.asset(
                        icon.microphone,
                        color: color.dark50,
                        width: 32.0,
                        height: 32.0,
                      ),
                    ),
                  ),
                ),
              );
            },
            selector: (context, state) => state.isPracticeRecord,
          ),
        ),
        Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              "Practice",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: color.dark20,
                fontSize: 14.0,
                fontFamily: font.semiBold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
