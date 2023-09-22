// ignore_for_file: deprecated_member_use, must_be_immutable, use_build_context_synchronously

import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/core/view/widget/textfield/chat_textfield.dart';
import 'package:talkios/product/conversation/viewmodel/conversation_room_view_model.dart';

import '../../../util/provider/sound/dubbing_provider.dart';
import '../../../util/provider/sound/speech_provider.dart';

class InputMenu extends BaseStateless {
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function() sendMessage;
  final int conversationId;
  final String hintText;
  InputMenu({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.sendMessage,
    required this.conversationId,
    required this.hintText,
  });

  AudioPlayer player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: height(context: context, value: 0.09),
        ),
        ChatTextField(
          controller: controller,
          focusNode: focusNode,
          hintText: hintText,
        ),
        Selector<ConversationRoomViewModel, bool>(
          builder: (context, isEmpty, child) {
            return Positioned(
              right: 60.0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: !isEmpty ? 1.0 : 0.0,
                child: Material(
                  type: MaterialType.transparency,
                  child: IconButton(
                    onPressed: !isEmpty
                        ? () {
                            context
                                .read<DubbingProvider>()
                                .stop(); // Stop Dubbing
                            context
                                .read<ConversationRoomViewModel>()
                                .changeEmptyTextStatus(true);
                            HapticFeedback.heavyImpact();
                            controller.clear();
                          }
                        : () {},
                    icon: SvgPicture.asset(icon.close),
                  ),
                ),
              ),
            );
          },
          selector: (context, state) => state.isEmptyText,
        ),
        Selector<ConversationRoomViewModel, bool>(
          builder: (context, isEmpty, child) {
            return Positioned(
              right: 20.0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: !isEmpty ? 1.0 : 0.0,
                child: Material(
                  type: MaterialType.transparency,
                  child: IconButton(
                    onPressed: !isEmpty ? sendMessage : () {},
                    icon: SvgPicture.asset(icon.send),
                  ),
                ),
              ),
            );
          },
          selector: (context, state) => state.isEmptyText,
        ),
        Selector<ConversationRoomViewModel, bool>(
          builder: (context, isShow, child) {
            return AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              top: 0,
              left: isShow ? 75.0 : 0.0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isShow ? 1.0 : 0.0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(243, 243, 245, 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                      bottomRight: Radius.circular(16.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Please hold the button",
                      style: currentTextTheme(context).bodyLarge?.copyWith(
                            fontWeight: FontWeight.w400,
                            color: color.dark80,
                            fontSize: 12.0,
                            fontFamily: font.regular,
                          ),
                    ),
                  ),
                ),
              ),
            );
          },
          selector: (context, state) => state.isShowWarning,
        ),
        Positioned(
          left: 15.0,
          child: Material(
            type: MaterialType.transparency,
            child: GestureDetector(
              onTap: () async {
                context.read<DubbingProvider>().stop(); // Stop Dubbing
                await player.play(AssetSource(sound.voiceButton));
                context.read<ConversationRoomViewModel>().showWarning();
                Provider.of<SpeechProvider>(context, listen: false)
                    .getPermissionAndStartListening(context);
              },
              onLongPress: () async {
                context.read<DubbingProvider>().stop(); // Stop Dubbing
                await player.play(AssetSource(sound.voiceButton));
                await player.play(AssetSource(sound.voiceButton));
                HapticFeedback.heavyImpact();
                Provider.of<SpeechProvider>(context, listen: false).record();
                Provider.of<SpeechProvider>(context, listen: false)
                    .startListening();
              },
              onLongPressEnd: (details) async {
                Provider.of<SpeechProvider>(context, listen: false)
                    .stopListening();
                Provider.of<SpeechProvider>(context, listen: false).record();
                ConversationRoomViewModel provider =
                    context.read<ConversationRoomViewModel>();
                Future.delayed(
                  const Duration(seconds: 1),
                  () {
                    provider
                        .voiceText(context.read<SpeechProvider>().lastWords);
                    provider.changeEmptyTextStatus(false);
                    provider.sendAutomaticMessage(true);
                    Future.delayed(
                      const Duration(seconds: 1),
                      () async {
                        if (provider.isSendAutomaticMessage) {
                          context
                              .read<ConversationRoomViewModel>()
                              .changeEmptyTextStatus(true);
                          provider.addToChatList(provider.askController.text);
                          if (provider.askController.text.isNotEmpty) {
                            await provider.sendMessage(
                              context,
                              message: context.read<SpeechProvider>().lastWords,
                              conversationId: conversationId,
                            );
                          }
                        }
                      },
                    );
                  },
                );

                await player.play(AssetSource(sound.voiceButton));
                HapticFeedback.heavyImpact();
              },
              child: Selector<SpeechProvider, bool>(
                builder: (context, record, child) {
                  return AvatarGlow(
                    endRadius: 35.0,
                    glowColor: color.dark20,
                    animate: record,
                    duration: const Duration(milliseconds: 500),
                    repeat: true,
                    repeatPauseDuration: const Duration(milliseconds: 100),
                    showTwoGlows: true,
                    curve: Curves.fastOutSlowIn,
                    child: CircleAvatar(
                      radius: 23.0,
                      backgroundColor: color.dark10,
                      child: SvgPicture.asset(
                        icon.microphone,
                        color: color.dark50,
                        width: 22.0,
                        height: 22.0,
                      ),
                    ),
                  );
                },
                selector: (context, state) => state.isRecord,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
