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
import 'package:talkios/core/view/widget/menu/bottom_menu.dart';
import 'package:talkios/core/view/widget/menu/header_menu.dart';
import 'package:talkios/product/conversation/model/chat_model.dart';
import 'package:talkios/product/conversation/viewmodel/bottom_menu_view_model.dart';
import 'package:talkios/product/conversation/viewmodel/conversation_room_view_model.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../core/constant/config_constant.dart';
import '../../../core/util/connectivity_service.dart';
import '../../../core/util/provider/sound/dubbing_provider.dart';
import '../../../core/view/widget/menu/input_menu.dart';

class ConversationRoomView extends StatefulWidget {
  final int conversationId;
  final String userProfilePhoto;
  final String aiProfilePhoto;
  final String scenarioName;
  final int score;
  final String fromWhere;

  const ConversationRoomView({
    Key? key,
    required this.conversationId,
    required this.userProfilePhoto,
    required this.aiProfilePhoto,
    required this.scenarioName,
    required this.score,
    required this.fromWhere,
  }) : super(key: key);

  @override
  State<ConversationRoomView> createState() => _ConversationRoomViewState();
}

class _ConversationRoomViewState extends BaseState<ConversationRoomView> {
  ConversationRoomViewModel viewModel = ConversationRoomViewModel();
  late Future<void> messagesFuture;

  final ScrollController scrollController = ScrollController();
  DubbingProvider dubbingProvider = DubbingProvider();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    messagesFuture = context
        .read<ConversationRoomViewModel>()
        .getAllMessages(widget.conversationId);
  }

  @override
  Widget build(BuildContext context) {
    return Provider.of<ConnectivityService>(context, listen: true)
                .connectionStatus ==
            ConnectionStatus.Online
        ? conversationRoomView()
        : Center(
            child: Lottie.asset(lottie.networkError),
          );
  }

  GestureDetector conversationRoomView() {
    return GestureDetector(
      onTap: () => viewModel.deFocus(),
      child: Scaffold(
        key: _scaffoldKey,
        body: Selector<ConversationRoomViewModel, bool>(
          builder: (context, firstConversation, child) {
            return Stack(
              children: [
                noFirstConversation(),
                Selector<ConversationRoomViewModel, bool>(
                  builder: (context, isFirst, child) {
                    return isFirst
                        ? Positioned.fill(
                            child: AnimatedOpacity(
                              opacity: isFirst ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: InkWell(
                                onTap: isFirst
                                    ? () => context
                                        .read<ConversationRoomViewModel>()
                                        .changeStatusFirstConversation(false)
                                    : () {},
                                child: Image.asset(
                                  image.firstChat,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : const Center();
                  },
                  selector: (context, state) => state.isFirstConversation,
                ),
              ],
            );
          },
          selector: (context, state) => state.isFirstConversation,
        ),
      ),
    );
  }

  Stack noFirstConversation() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            image.background,
            fit: BoxFit.cover,
          ),
        ),
        FutureBuilder(
          future: messagesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loadingState();
            } else if (snapshot.connectionState == ConnectionState.done) {
              return conversationRoom(context);
            } else {
              return const Text("Error");
            }
          },
        ),
      ],
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
              dubbingProvider: dubbingProvider,
              fromWhere: "",
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

  Column conversationRoom(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        spacer(height: 56.0),
        Consumer<ConversationRoomViewModel>(
          builder: (context, provider, child) {
            return Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: HeaderMenu(
                      dubbingProvider: dubbingProvider,
                      fromWhere: widget.fromWhere,
                      score: widget.score,
                      scenarioName: widget.scenarioName,
                      userProfilePhoto: widget.userProfilePhoto,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 18.0, right: 18.0, top: 10.0),
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
                                    padding:
                                        const EdgeInsets.only(bottom: 30.0),
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
                                      (provider.chats[0]
                                                  .conversationCompletionCount ==
                                              "1.00" &&
                                          index == 0)
                                  ? SingleChildScrollView(
                                      child: !provider.isContinue
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ChatCard(
                                                  chats: provider.chats,
                                                  messageId: model.id!,
                                                  scaffoldKey: _scaffoldKey,
                                                  sendModel:
                                                      viewModel.sendModel,
                                                  dubbingProvider:
                                                      dubbingProvider,
                                                  conversationId:
                                                      widget.conversationId,
                                                  viewModel: viewModel,
                                                  model: model,
                                                  index: index,
                                                  userProfilePhoto:
                                                      widget.userProfilePhoto,
                                                  aiProfilePhoto:
                                                      widget.aiProfilePhoto,
                                                ),
                                                completeQuestion(
                                                    context, model, provider),
                                              ],
                                            )
                                          : ChatCard(
                                              chats: provider.chats,
                                              messageId: model.id!,
                                              scaffoldKey: _scaffoldKey,
                                              sendModel: viewModel.sendModel,
                                              dubbingProvider: dubbingProvider,
                                              conversationId:
                                                  widget.conversationId,
                                              viewModel: viewModel,
                                              model: model,
                                              index: index,
                                              userProfilePhoto:
                                                  widget.userProfilePhoto,
                                              aiProfilePhoto:
                                                  widget.aiProfilePhoto,
                                            ),
                                    )
                                  : ChatCard(
                                      chats: provider.chats,
                                      messageId: model.id!,
                                      scaffoldKey: _scaffoldKey,
                                      sendModel: viewModel.sendModel,
                                      dubbingProvider: dubbingProvider,
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
                  Selector<ConversationRoomViewModel, bool>(
                    builder: (context, isContinue, child) {
                      return AbsorbPointer(
                        absorbing: isContinue ? false : !provider.isActiveChat,
                        child: InputMenu(
                          viewModel: viewModel,
                          dubbingProvider: dubbingProvider,
                          hintText: isContinue
                              ? "Ask anything"
                              : provider.isActiveChat
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
                              dubbingProvider.stop(); // Stop Dubbing
                              context.read<DubbingProvider>().stop();
                              AudioPlayer player = AudioPlayer();
                              await player.play(AssetSource(sound.chatBubble));
                              String message = provider.askController.text;
                              provider.addToChatList(
                                  provider.askController.text,
                                  (provider.chats[0].id! + 1).toString());

                              HapticFeedback.heavyImpact();
                              viewModel.askFocusNode.unfocus();

                              provider.changeEmptyTextStatus(true);
                              analyticInstance.logEvent(
                                  name: 'start_messaging_text');
                              context
                                  .read<BottomMenuViewModel>()
                                  .openClue(false);
                              context
                                  .read<BottomMenuViewModel>()
                                  .openTask(false);
                              await provider.sendMessage(
                                context,
                                message: message,
                                conversationId: widget.conversationId,
                              );
                            }
                          },
                        ),
                      );
                    },
                    selector: (context, state) => state.isContinue,
                  ),
                ],
              ),
            );
          },
        ),
        BottomMenu(
          conversationId: widget.conversationId,
          viewModel: viewModel,
        ),
        spacer(height: 50.0),
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
                  Expanded(
                    child: AppButton(
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
                  ),
                  spacer(width: 10.0),
                  Selector<ConversationRoomViewModel, bool>(
                    builder: (context, endChat, child) {
                      return Expanded(
                        child: AppButton(
                          widthValue: width(0.3),
                          heightValue: height(0.05),
                          text: "Complete",
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
                            dubbingProvider.stop();
                            context.read<DubbingProvider>().stop();
                            context
                                .read<ConversationRoomViewModel>()
                                .continueChat(false);
                            provider.tapEndChat();
                            await viewModel.conversationUpdate(
                              context,
                              true,
                              widget.conversationId,
                            );
                            provider.tapEndChat();
                          },
                        ),
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
}
