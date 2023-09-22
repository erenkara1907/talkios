// ignore_for_file: must_be_immutable, deprecated_member_use, use_build_context_synchronously

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:talkios/core/view/base/base_state.dart';
import 'package:talkios/core/view/widget/button/app_button.dart';
import 'package:talkios/core/view/widget/card/chat_card.dart';
import 'package:talkios/core/view/widget/card/menu_card.dart';
import 'package:talkios/core/view/widget/menu/header_menu.dart';
import 'package:talkios/core/view/widget/menu/input_menu.dart';
import 'package:talkios/product/conversation/model/chat_model.dart';
import 'package:talkios/product/conversation/model/task_model.dart';
import 'package:talkios/product/conversation/viewmodel/conversation_room_view_model.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../core/util/provider/sound/dubbing_provider.dart';

class ConversationRoomView extends StatefulWidget {
  final int conversationId;
  final String userProfilePhoto;
  final String aiProfilePhoto;
  final String scenarioName;
  final int score;

  const ConversationRoomView({
    Key? key,
    required this.conversationId,
    required this.userProfilePhoto,
    required this.aiProfilePhoto,
    required this.scenarioName,
    required this.score,
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
            HeaderMenu(
              score: widget.score,
              userProfilePhoto: widget.userProfilePhoto,
              scenarioName: widget.scenarioName,
            ),
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
            // BottomMenu(
            //   models: viewModel.menuCards,
            // ),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: HeaderMenu(
            score: widget.score,
            scenarioName: widget.scenarioName,
            userProfilePhoto: widget.userProfilePhoto,
          ),
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
                print(
                    "count : ${provider.chats[0].conversationCompletionCount}");
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
                    : (provider.chats.last.endConversation == 1 &&
                                index == 0 &&
                                provider.isActiveChat) ||
                            provider.chats[0].conversationCompletionCount ==
                                "1.0"
                        ? SingleChildScrollView(
                            child: !provider.isContinue
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ChatCard(
                                        conversationId: widget.conversationId,
                                        viewModel: viewModel,
                                        model: model,
                                        index: index,
                                        userProfilePhoto:
                                            widget.userProfilePhoto,
                                        aiProfilePhoto: widget.aiProfilePhoto,
                                      ),
                                      completeQuestion(
                                          context, model, provider),
                                    ],
                                  )
                                : ChatCard(
                                    conversationId: widget.conversationId,
                                    viewModel: viewModel,
                                    model: model,
                                    index: index,
                                    userProfilePhoto: widget.userProfilePhoto,
                                    aiProfilePhoto: widget.aiProfilePhoto,
                                  ),
                          )
                        : ChatCard(
                            conversationId: widget.conversationId,
                            viewModel: viewModel,
                            model: model,
                            index: index,
                            userProfilePhoto: widget.userProfilePhoto,
                            aiProfilePhoto: widget.aiProfilePhoto,
                          );
              },
            ),
          ),
        ),
        AbsorbPointer(
          absorbing: !provider.isActiveChat,
          child: InputMenu(
            hintText: provider.isActiveChat
                ? "Ask anything"
                : "You have completed this scenario",
            conversationId: widget.conversationId,
            controller: provider.askController,
            focusNode: viewModel.askFocusNode,
            sendMessage: () async {
              if (provider.isTyping) {
                showTopSnackBar(
                  Overlay.of(context),
                  const CustomSnackBar.error(
                    message:
                        "You cannot send multiple message at the same time",
                  ),
                );
              } else if (provider.askController.text.isNotEmpty) {
                context.read<DubbingProvider>().stop(); // Stop Dubbing
                AudioPlayer player = AudioPlayer();
                await player.play(AssetSource(sound.chatBubble));
                String message = provider.askController.text;
                provider.addToChatList(provider.askController.text);

                HapticFeedback.heavyImpact();
                viewModel.askFocusNode.unfocus();

                provider.changeEmptyTextStatus(true);

                await provider.sendMessage(
                  context,
                  message: message,
                  conversationId: widget.conversationId,
                );
              }
            },
          ),
        ),
        AbsorbPointer(
          absorbing: !provider.isActiveChat,
          child: bottomSection(provider, context),
        ),
        spacer(height: 25.0),
      ],
    );
  }

  Align completeQuestion(BuildContext context, ChatModel model,
      ConversationRoomViewModel provider) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth:
              MediaQuery.of(context).size.width * 0.7, // Maksimum genişlik
        ),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(243, 243, 245, 1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(model.role == "user" ? 20.0 : 0.0),
            bottomLeft: const Radius.circular(20.0),
            bottomRight: const Radius.circular(20.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 21.0,
            horizontal: 29.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good job you've sent the required number of messages for this conversation. Do you want to continue?",
                style: currentTextTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: color.dark100,
                  fontSize: 14.0,
                  fontFamily: font.medium,
                ),
              ),
              spacer(height: 25.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppButton(
                    widthValue: width(0.3),
                    heightValue: height(0.05),
                    text: "Continue",
                    borderRadius: 66.0,
                    textStyle: currentTextTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: color.background,
                      fontSize: 14.0,
                      fontFamily: font.bold,
                    ),
                    backgroundColor: color.dark70,
                    onPressed: () => provider.continueChat(true),
                  ),
                  Selector<ConversationRoomViewModel, bool>(
                    builder: (context, endChat, child) {
                      return AppButton(
                        widthValue: width(0.2),
                        heightValue: height(0.05),
                        text: "Review",
                        isLoading: endChat,
                        textStyle: currentTextTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: color.background,
                          fontSize: 14.0,
                          fontFamily: font.bold,
                        ),
                        borderRadius: 66.0,
                        backgroundColor: color.softBlue,
                        onPressed: () async {
                          context.read<DubbingProvider>().stop();
                          provider.tapEndChat();
                          await viewModel.conversationUpdate(
                            context,
                            true,
                            widget.conversationId,
                          );
                          provider.tapEndChat();
                        },
                      );
                    },
                    selector: (context, state) => state.endChatTap,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  AnimatedPadding bottomSection(
      ConversationRoomViewModel provider, BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 600),
      padding: const EdgeInsets.only(
        left: 18.0,
        right: 18.0,
      ),
      child: Column(
        children: [
          // BottomMenu(
          //   models: provider.menuCards,
          // ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              MenuCard(
                model: provider.menuCards[0],
                onTap: () {
                  if (provider.isOpenTasks) {
                    provider.openTask(false);
                  } else {
                    provider.openClue(false);
                    provider.openTask(true);
                  }
                },
              ),
              MenuCard(
                model: provider.menuCards[1],
                onTap: () {
                  if (provider.isOpenClue) {
                    provider.openClue(false);
                  } else {
                    provider.openTask(false);
                    provider.openClue(true);
                  }
                },
              ),
            ],
          ),
          provider.isOpenTasks
              ? FutureBuilder(
                  future: viewModel.getTasks(widget.conversationId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Lottie.asset(
                          lottie.loadingMessage,
                          width: 24.0,
                          height: 24.0,
                        ),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          addAutomaticKeepAlives: false,
                          addRepaintBoundaries: false,
                          physics: const ClampingScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: viewModel.taskModel.data!.conversation!
                              .completedTasks!.length,
                          itemBuilder: (context, index) {
                            CompletedTask model = viewModel.taskModel.data!
                                .conversation!.completedTasks![index];
                            return task(
                              context,
                              model.title!,
                              index,
                              model.isComplete!
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            );
                          },
                        ),
                      );
                    } else {
                      return const Text("Error");
                    }
                  },
                )
              : !provider.isOpenClue
                  ? const Center()
                  : futureSuggest()
        ],
      ),
    );
  }

  FutureBuilder<dynamic> futureSuggest() {
    return FutureBuilder(
        future: viewModel.suggestResponse(widget.conversationId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Lottie.asset(
                lottie.loadingMessage,
                width: 24.0,
                height: 24.0,
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    viewModel.suggestModel.data!.suggestResponse!,
                    style: currentTextTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: color.dark100,
                      fontSize: 14.0,
                      fontFamily: font.regular,
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Text("error");
          }
        });
  }

  Row task(
      BuildContext context, String task, int index, TextDecoration decoration) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "●  ",
          style: currentTextTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w400,
            color: color.dark100,
            fontSize: 14.0,
            fontFamily: font.regular,
          ),
        ),
        Text(
          task,
          style: currentTextTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w400,
            color: color.dark100,
            fontSize: 14.0,
            fontFamily: font.regular,
            decoration: decoration,
          ),
        ),
        index == 1
            ? Text(
                " (1/4)",
                style: currentTextTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color.dark100,
                  fontSize: 14.0,
                  fontFamily: font.bold,
                ),
              )
            : const Center()
      ],
    );
  }
}
