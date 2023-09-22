// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/product/conversation/viewmodel/conversation_room_view_model.dart';

import '../../../../product/conversation/model/chat_model.dart';
import '../../../util/provider/sound/dubbing_provider.dart';

class ChatCard extends BaseStateless {
  final int index;
  final ChatModel model;
  final String userProfilePhoto;
  final String aiProfilePhoto;
  final ConversationRoomViewModel viewModel;
  final int conversationId;

  const ChatCard({
    super.key,
    required this.index,
    required this.model,
    required this.userProfilePhoto,
    required this.aiProfilePhoto,
    required this.viewModel,
    required this.conversationId,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: model.role == "user" ? Alignment.topRight : Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(
            bottom: model.endConversation == 1 && index == 0 ? 10.0 : 30.0),
        child: Row(
          mainAxisAlignment: model.role == "user"
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width *
                    0.7, // Maksimum genişlik
              ),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(243, 243, 245, 1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(model.role == "user" ? 20.0 : 0.0),
                  bottomLeft: Radius.circular(
                      model.endConversation == 1 && index == 0 ? 0.0 : 20.0),
                  bottomRight: Radius.circular(
                      model.endConversation == 1 && index == 0 ? 0.0 : 20.0),
                  topRight: Radius.circular(model.role == "user" ? 0.0 : 20.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 21.0,
                  horizontal: 10.0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    model.role != "user"
                        ? CircleAvatar(
                            radius: 15.0,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: aiProfilePhoto,
                                fit: BoxFit.cover,
                                width: 30.0, // 2 * radius
                                height: 30.0, // 2 * radius
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          )
                        : const SizedBox(width: 0),
                    const SizedBox(width: 10),
                    Selector<ConversationRoomViewModel, int>(
                      builder: (context, messageIndex, child) {
                        return messageIndex != index
                            ? Flexible(
                                child: Text(
                                  model.message,
                                  style: currentTextTheme(context)
                                      .bodyLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: color.dark100,
                                        fontSize: 14.0,
                                        fontFamily: font.regular,
                                      ),
                                ),
                              )
                            : FutureBuilder(
                                future: viewModel.translate(
                                  conversationId: conversationId,
                                  messageId: model.id,
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Lottie.asset(
                                      lottie.loadingMessage,
                                      width: 32.0,
                                      height: 32.0,
                                    );
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return Flexible(
                                      child: Text(
                                        viewModel.translationModel.data!
                                            .message!.message!,
                                        style: currentTextTheme(context)
                                            .bodyLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w400,
                                              color: color.dark100,
                                              fontSize: 14.0,
                                              fontFamily: font.regular,
                                            ),
                                      ),
                                    );
                                  } else {
                                    return const Text("Error");
                                  }
                                },
                              );
                      },
                      selector: (context, state) => state.messageIndex,
                    ),
                    const SizedBox(width: 10),
                    model.role == "user"
                        ? CircleAvatar(
                            radius: 15.0,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: userProfilePhoto,
                                fit: BoxFit.cover,
                                width: 30.0, // 2 * radius
                                height: 30.0, // 2 * radius
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          )
                        : const SizedBox(width: 0),
                  ],
                ),
              ),
            ),
            model.role != "user"
                ? Row(
                    children: [
                      spacer(width: 10.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 15.0,
                            backgroundColor:
                                const Color.fromRGBO(243, 243, 245, 1),
                            child: IconButton(
                              onPressed: () {
                                DubbingProvider _provider =
                                    context.read<DubbingProvider>();
                                if (_provider.isSpeaking) {
                                  _provider.stop();
                                } else {
                                  _provider.speak(model.message, index);
                                }
                              },
                              icon: Consumer<DubbingProvider>(
                                builder: (context, state, child) {
                                  return Icon(
                                    state.isSpeaking &&
                                            state.messageIndex == index
                                        ? Icons.stop
                                        : Icons.mic,
                                    size: 15.0,
                                    color: state.isSpeaking &&
                                            state.messageIndex == index
                                        ? Colors.red
                                        : color.dark100,
                                  );
                                },
                              ),
                            ),
                          ),
                          spacer(height: 10.0),
                          Selector<ConversationRoomViewModel, int>(
                            builder: (context, messageIndex, child) {
                              return CircleAvatar(
                                radius: 15.0,
                                backgroundColor: messageIndex == index
                                    ? color.cyan.withOpacity(0.6)
                                    : const Color.fromRGBO(243, 243, 245, 1),
                                child: IconButton(
                                  onPressed: () {
                                    context.read<DubbingProvider>().stop();
                                    ConversationRoomViewModel provider = context
                                        .read<ConversationRoomViewModel>();

                                    if (provider.messageIndex != index) {
                                      provider.changeMessageIndex(index);
                                    } else {
                                      provider.changeMessageIndex(-1);
                                    }
                                  },
                                  icon: Icon(
                                    Icons.translate,
                                    size: 15.0,
                                    color: messageIndex == index
                                        ? color.background
                                        : color.dark100,
                                  ),
                                ),
                              );
                            },
                            selector: (context, state) => state.messageIndex,
                          ),
                        ],
                      ),
                    ],
                  )
                : const Center(),
          ],
        ),
      ),
    );
  }
}
