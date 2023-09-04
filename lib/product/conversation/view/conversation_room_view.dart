// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:talkios/core/view/base/base_state.dart';
import 'package:talkios/core/view/widget/card/chat_card.dart';
import 'package:talkios/core/view/widget/menu/header_menu.dart';
import 'package:talkios/core/view/widget/menu/input_menu.dart';
import 'package:talkios/product/conversation/model/chat_model.dart';
import 'package:talkios/product/conversation/viewmodel/conversation_room_view_model.dart';

import '../../../core/view/widget/menu/bottom_menu.dart';

class ConversationRoomView extends StatefulWidget {
  final int conversationId;
  final String userProfilePhoto;
  final String aiProfilePhoto;

  const ConversationRoomView({
    Key? key,
    required this.conversationId,
    required this.userProfilePhoto,
    required this.aiProfilePhoto,
  }) : super(key: key);

  @override
  State<ConversationRoomView> createState() => _ConversationRoomViewState();
}

class _ConversationRoomViewState extends BaseState<ConversationRoomView> {
  ConversationRoomViewModel viewModel = ConversationRoomViewModel();
  late Future<void> messagesFuture;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    messagesFuture = context
        .read<ConversationRoomViewModel>()
        .getAllMessages(widget.conversationId);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => viewModel.deFocus(),
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                image.background,
                fit: BoxFit.cover,
              ),
            ),
            Consumer<ConversationRoomViewModel>(
              builder: (context, chatProvider, child) {
                return FutureBuilder(
                  future: messagesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return loadingState();
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return conversationRoom(context, chatProvider);
                    } else {
                      return const Text("Error");
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Shimmer loadingState() {
    return Shimmer.fromColors(
      baseColor: color.dark10,
      highlightColor: color.dark30,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spacer(height: 56.0),
            const HeaderMenu(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return Align(
                      alignment: index % 2 == 0
                          ? Alignment.topLeft
                          : Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: Container(
                          width: width(0.7),
                          height: height(0.1),
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(243, 243, 245, 1),
                            borderRadius: BorderRadius.only(
                              bottomLeft: const Radius.circular(20.0),
                              bottomRight: const Radius.circular(20.0),
                              topRight:
                                  Radius.circular(index % 2 == 0 ? 20.0 : 0.0),
                              topLeft:
                                  Radius.circular(index % 2 == 0 ? 0.0 : 20.0),
                            ),
                          ),
                          child: Lottie.asset(
                            lottie.loadingMessage,
                            height: 35.0,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              width: width(1.0),
              height: height(0.06),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: color.background,
              ),
            ),
            BottomMenu(
              models: viewModel.menuCards,
              onTap: () {},
            ),
            spacer(height: 25.0),
          ],
        ),
      ),
    );
  }

  Column conversationRoom(
      BuildContext context, ConversationRoomViewModel provider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        spacer(height: 56.0),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.0),
          child: HeaderMenu(),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 10.0),
            child: ListView.builder(
              controller: scrollController,
              addSemanticIndexes: false,
              addAutomaticKeepAlives: false,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const ClampingScrollPhysics(),
              reverse: true,
              itemCount: provider.chats.length,
              itemBuilder: (context, index) {
                ChatModel model = provider.chats[index];
                return model.message == "Loading" && model.id == -2
                    ? Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(243, 243, 245, 1),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                            child: Lottie.asset(
                              lottie.loadingMessage,
                              height: 35.0,
                            ),
                          ),
                        ),
                      )
                    : ChatCard(
                        model: model,
                        index: index,
                        userProfilePhoto: widget.userProfilePhoto,
                        aiProfilePhoto: widget.aiProfilePhoto,
                      );
              },
            ),
          ),
        ),
        InputMenu(
          conversationId: widget.conversationId,
          controller: provider.askController,
          focusNode: viewModel.askFocusNode,
          sendMessage: () async {
            if (provider.askController.text.isNotEmpty) {
              AudioPlayer player = AudioPlayer();
              await player.play(AssetSource(sound.chatBubble));
              String message = provider.askController.text;
              provider.addToChatList(provider.askController.text);

              HapticFeedback.heavyImpact();
              viewModel.askFocusNode.unfocus();

              provider.changeEmptyTextStatus(true);

              await provider.sendMessage(
                message: message,
                conversationId: widget.conversationId,
              );
            }
          },
        ),
        AnimatedPadding(
          duration: const Duration(milliseconds: 600),
          padding: const EdgeInsets.only(
            left: 18.0,
            right: 18.0,
          ),
          child: Column(
            children: [
              BottomMenu(
                models: provider.menuCards,
                onTap: () {
                  if (provider.menuCards[0].id == 1) {
                    context.read<ConversationRoomViewModel>().openTask();
                  }
                },
              ),
              provider.isOpenTasks
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          spacer(height: 12.0),
                          task(context, "Ask if they like to read books"),
                          spacer(height: 10.0),
                          task(context, "Ask if they enjoy watching movies"),
                          spacer(height: 10.0),
                          task(context, "Ask if they have any favorite sports"),
                        ],
                      ),
                    )
                  : const Center(),
            ],
          ),
        ),
        spacer(height: 25.0),
      ],
    );
  }

  Text task(BuildContext context, String task) {
    return Text(
      "●  $task",
      style: currentTextTheme.bodyLarge?.copyWith(
        fontWeight: FontWeight.w400,
        color: color.dark100,
        fontSize: 14.0,
        fontFamily: font.regular,
      ),
    );
  }
}
