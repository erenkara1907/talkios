// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/util/provider/sound/dubbing_provider.dart';
import 'package:talkios/core/view/base/base_state.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../product/conversation/viewmodel/bottom_menu_view_model.dart';
import '../../../../product/conversation/viewmodel/conversation_room_view_model.dart';
import '../../../constant/config_constant.dart';
import '../../../util/provider/sound/speech_provider.dart';

class VoiceButton extends StatefulWidget {
  DubbingProvider dubbingProvider;
  ConversationRoomViewModel viewModel;
  AudioPlayer player;
  int conversationId;
  String gender;
  VoiceButton({
    Key? key,
    required this.dubbingProvider,
    required this.viewModel,
    required this.player,
    required this.conversationId,
    required this.gender,
  }) : super(key: key);

  @override
// ignore: library_private_types_in_public_api
  _VoiceButtonState createState() => _VoiceButtonState();
}

Future<void> haveMessage(
  BuildContext context, {
  required int conversationId,
  required ConversationRoomViewModel viewModel,
}) async {
  Provider.of<SpeechProvider>(context, listen: false).record(false);
  context.read<SpeechProvider>().isVoiceRecording = false;
  Provider.of<SpeechProvider>(context, listen: false).stopListening();
  await context.read<ConversationRoomViewModel>().stopRecording();

  ConversationRoomViewModel provider =
      context.read<ConversationRoomViewModel>();
  provider.voiceText(context.read<SpeechProvider>().lastWords);
  provider.changeEmptyTextStatus(false);
  provider.sendAutomaticMessage(true);
  if (provider.isSendAutomaticMessage &&
      provider.askController.text.isNotEmpty) {
    context.read<ConversationRoomViewModel>().changeEmptyTextStatus(true);
    provider.addToChatList(
        provider.askController.text, (provider.chats[0].id! + 1).toString());
    analyticInstance.logEvent(name: 'start_messaging_voice');

    viewModel.askFocusNode.unfocus();
    context.read<BottomMenuViewModel>().openClue(false);
    context.read<BottomMenuViewModel>().openTask(false);
    context.read<BottomMenuViewModel>().isOpenTranslate = false;
    await provider.sendMessage(
      context: context,
      message: context.read<SpeechProvider>().lastWords,
      conversationId: conversationId,
      gender: "female",
      path: context.read<ConversationRoomViewModel>().path,
      isVoice: true,
    );

    context.read<SpeechProvider>().lastWords = "";
    provider.askController.text = "";
  } else {}
}

Future<void> haveNotMessage(BuildContext context) async {}

class _VoiceButtonState extends BaseState<VoiceButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onTap: () async {
          context.read<ConversationRoomViewModel>().updateScore("");
          Provider.of<SpeechProvider>(context, listen: false)
              .getPermissionAndStartListening(context);
          context.read<DubbingProvider>().stop();

          if (!context.read<ConversationRoomViewModel>().isTyping) {
            if (!context.read<SpeechProvider>().isRecord &&
                !context.read<SpeechProvider>().isVoiceRecording) {
              HapticFeedback.heavyImpact();
              await widget.player.play(AssetSource(sound.voiceButton));

              context.read<SpeechProvider>().isVoiceRecording = true;
              Provider.of<SpeechProvider>(context, listen: false).record(true);
              await Provider.of<SpeechProvider>(context, listen: false)
                  .startListening();
              await context.read<ConversationRoomViewModel>().startRecording();
              Provider.of<SpeechProvider>(context, listen: false)
                  .stopListening();
              await context.read<ConversationRoomViewModel>().stopRecording();
            } else {
              haveMessage(
                context,
                conversationId: widget.conversationId,
                viewModel: widget.viewModel,
              );
            }
          } else {
            showTopSnackBar(
              Overlay.of(context),
              const CustomSnackBar.error(
                message: "You cannot send multiple message at the same time",
              ),
            );
          }
        },
        onLongPress: () {
          context.read<ConversationRoomViewModel>().onTapVoiceButton = true;
          context.read<ConversationRoomViewModel>().showWarning();
          Future.delayed(
            const Duration(seconds: 1),
            () {
              context.read<ConversationRoomViewModel>().onTapVoiceButton =
                  false;
            },
          );
        },
        child: Consumer<SpeechProvider>(
          builder: (ctx, state, child) {
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
                        state.isVoiceRecording
                            ? "Tap when done"
                            : "Tap to speak",
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
                Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: state.isRecord ? 1.0 : 0.0,
                      child: SizedBox(
                        width: 235.0,
                        height: 100.0,
                        child: Lottie.asset(lottie.recordingBlack,
                            fit: BoxFit.fill),
                      ),
                    ),
                    AvatarGlow(
                      endRadius: 50.0,
                      glowColor: const Color.fromRGBO(85, 141, 240, 1),
                      animate: state.isVoiceRecording,
                      duration: const Duration(milliseconds: 500),
                      repeat: true,
                      repeatPauseDuration: const Duration(milliseconds: 100),
                      showTwoGlows: true,
                      curve: Curves.fastOutSlowIn,
                      child: AnimatedContainer(
                        width: 73.0,
                        height: 73.0,
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: state.isVoiceRecording
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
                            color: state.isVoiceRecording
                                ? color.background
                                : const Color.fromRGBO(47, 67, 141, 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
