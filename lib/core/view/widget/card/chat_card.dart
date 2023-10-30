// ignore_for_file: no_leading_underscores_for_local_identifiers, must_be_immutable, use_build_context_synchronously, unused_local_variable

import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/util/provider/chat_tools_provider.dart';
import 'package:talkios/core/util/provider/image/image_upload_view_model.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/core/view/widget/card/pronunciation_card.dart';
import 'package:talkios/core/view/widget/card/tip_card.dart';
import 'package:talkios/core/view/widget/card/translate_card.dart';
import 'package:talkios/product/conversation/viewmodel/conversation_room_view_model.dart';

import '../../../../product/conversation/model/chat_model.dart';
import '../../../util/provider/sound/dubbing_provider.dart';

class ChatCard extends BaseStateless {
  final int index;
  final ChatModel model;
  final SendMessageModel sendModel;
  final String userProfilePhoto;
  final String aiProfilePhoto;
  final ConversationRoomViewModel viewModel;
  final int conversationId;
  final DubbingProvider dubbingProvider;
  final int messageId;
  final List<ChatModel> chats;
  final String gender;
  final GlobalKey<ScaffoldState> scaffoldKey;

  ChatCard({
    super.key,
    required this.index,
    required this.model,
    required this.sendModel,
    required this.userProfilePhoto,
    required this.aiProfilePhoto,
    required this.viewModel,
    required this.conversationId,
    required this.dubbingProvider,
    required this.messageId,
    required this.chats,
    required this.gender,
    required this.scaffoldKey,
  });

  AudioPlayer player = AudioPlayer();

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
            model.role == "user"
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      card(context),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Selector<ConversationRoomViewModel, String>(
                            builder: (ctx, betterSentence, child) {
                              return model.betterSentence != null ||
                                      betterSentence.isNotEmpty
                                  ? translateChip(context)
                                  : const Center();
                            },
                            selector: (context, state) => state.betterSentence,
                          ),
                          Selector<ConversationRoomViewModel, String>(
                            builder: (ctx, betterSentence, child) {
                              return model.betterSentence != null ||
                                      betterSentence.isNotEmpty
                                  ? tipChip(context)
                                  : const Center();
                            },
                            selector: (context, state) => state.betterSentence,
                          ),
                          Consumer<ConversationRoomViewModel>(
                            builder: (ctx, modelState, child) {
                              return model.sound != null &&
                                          model.sound
                                              .toString()
                                              .contains("http") ||
                                      (modelState.indexesWithSound
                                          .contains(model.id))
                                  ? pronunciationChip(context)
                                  : const Center();
                            },
                          ),
                        ],
                      ),
                      spacer(height: 10.0),
                      Selector<ChatToolsProvider, bool>(
                        builder: (ctx, isTranslate, child) {
                          return isTranslate &&
                                  context
                                          .read<ChatToolsProvider>()
                                          .messageIndex ==
                                      index
                              ? TranslateCard(
                                  viewModel: viewModel,
                                  conversationId: conversationId,
                                  messageId: messageId,
                                )
                              : const Center();
                        },
                        selector: (context, state) => state.isTranslate,
                      ),
                      Selector<ChatToolsProvider, bool>(
                        builder: (ctx, isTip, child) {
                          return isTip &&
                                  context
                                          .read<ChatToolsProvider>()
                                          .messageIndex ==
                                      index
                              ? TipCard(
                                  betterSentence: model.betterSentence ??
                                      context
                                          .read<ConversationRoomViewModel>()
                                          .betterSentence,
                                )
                              : const Center();
                        },
                        selector: (context, state) => state.isTip,
                      ),
                      Selector<ChatToolsProvider, bool>(
                        builder: (ctx, isPro, child) {
                          return isPro &&
                                  context
                                          .read<ChatToolsProvider>()
                                          .messageIndex ==
                                      index
                              ? PronunciationCard(
                                  model: model,
                                  index: index,
                                  message: model.message ?? "",
                                  dubbingProvider: dubbingProvider,
                                  aiProfilePhoto: aiProfilePhoto,
                                  userProfilePhoto: userProfilePhoto,
                                  viewModel: viewModel,
                                  player: player,
                                  gender: gender,
                                  chats: chats,
                                  conversationId: conversationId,
                                  messageId: messageId,
                                )
                              : const Center();
                        },
                        selector: (context, state) => state.isPronunciation,
                      ),
                    ],
                  )
                : card(context),
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
                                  _provider.speak(
                                    model.message!,
                                    index,
                                  );
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
                                    dubbingProvider.stop();
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

  InkWell translateChip(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      overlayColor: MaterialStateProperty.all<Color?>(Colors.transparent),
      onTap: () {
        ChatToolsProvider _provider = context.read<ChatToolsProvider>();

        _provider.messageIndex = index;
        if (_provider.isTip || _provider.isPronunciation) {
          _provider.isTip = false;
          _provider.isPronunciation = false;

          _provider.isTranslate = true;
        } else {
          _provider.isTranslate = !_provider.isTranslate;
        }
      },
      child: Selector<ChatToolsProvider, bool>(
        builder: (ctx, isTranslate, child) {
          return Chip(
            backgroundColor: Color.fromRGBO(
                85,
                141,
                240,
                isTranslate &&
                        context.read<ChatToolsProvider>().messageIndex == index
                    ? 1.0
                    : 0.3),
            label: Icon(
              Icons.translate,
              size: 18.0,
              color: isTranslate &&
                      context.read<ChatToolsProvider>().messageIndex == index
                  ? color.background
                  : const Color.fromRGBO(
                      85,
                      141,
                      240,
                      1,
                    ),
            ),
          );
        },
        selector: (context, state) => state.isTranslate,
      ),
    );
  }

  InkWell tipChip(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      overlayColor: MaterialStateProperty.all<Color?>(Colors.transparent),
      onTap: () {
        ChatToolsProvider _provider = context.read<ChatToolsProvider>();
        _provider.messageIndex = index;
        if (_provider.isTranslate || _provider.isPronunciation) {
          _provider.isTranslate = false;
          _provider.isPronunciation = false;

          _provider.isTip = true;
        } else {
          _provider.isTip = !_provider.isTip;
        }
      },
      child: Selector<ChatToolsProvider, bool>(
        builder: (ctx, isTip, child) {
          return Chip(
            backgroundColor: Color.fromRGBO(
                85,
                141,
                240,
                isTip && context.read<ChatToolsProvider>().messageIndex == index
                    ? 1.0
                    : 0.3),
            label: Text(
              "Tip",
              style: currentTextTheme(context).bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isTip &&
                            context.read<ChatToolsProvider>().messageIndex ==
                                index
                        ? color.background
                        : const Color.fromRGBO(85, 141, 240, 1),
                    fontSize: 12.0,
                    fontFamily: font.semiBold,
                  ),
            ),
          );
        },
        selector: (context, state) => state.isTip,
      ),
    );
  }

  InkWell pronunciationChip(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      overlayColor: MaterialStateProperty.all<Color?>(Colors.transparent),
      onTap: () {
        context.read<ConversationRoomViewModel>().updateScore("");
        ChatToolsProvider _provider = context.read<ChatToolsProvider>();
        _provider.messageIndex = index;
        if (_provider.isTip || _provider.isTranslate) {
          _provider.isTip = false;
          _provider.isTranslate = false;
          _provider.isPronunciation = true;
        } else {
          _provider.isPronunciation = !_provider.isPronunciation;
        }
      },
      child: Selector<ChatToolsProvider, bool>(
        builder: (ctx, isPro, child) {
          return Chip(
            backgroundColor: Color.fromRGBO(
                85,
                141,
                240,
                isPro && context.read<ChatToolsProvider>().messageIndex == index
                    ? 1.0
                    : 0.3),
            label: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  icon.fluentPerson,
                  width: 16.0,
                  height: 16.0,
                  color: isPro &&
                          context.read<ChatToolsProvider>().messageIndex ==
                              index
                      ? color.background
                      : null,
                ),
                spacer(width: 3.0),
                Text(
                  "%${model.score != null && model.score != 0 ? model.score : context.read<ConversationRoomViewModel>().score.isEmpty ? '' : context.read<ConversationRoomViewModel>().score}",
                  // "%${model.score ?? context.read<ConversationRoomViewModel>().score}",
                  style: currentTextTheme(context).bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isPro &&
                                context
                                        .read<ChatToolsProvider>()
                                        .messageIndex ==
                                    index
                            ? color.background
                            : const Color.fromRGBO(85, 141, 240, 1),
                        fontSize: 12.0,
                        fontFamily: font.semiBold,
                      ),
                )
              ],
            ),
          );
        },
        selector: (context, state) => state.isPronunciation,
      ),
    );
  }

  AnimatedContainer card(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.7, // Maksimum genişlik
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
                      child: Image.asset(icon.appIcon),
                    ),
                  )
                : const SizedBox(width: 0),
            const SizedBox(width: 10),
            Selector<ConversationRoomViewModel, int>(
              builder: (context, messageIndex, child) {
                return messageIndex != index
                    ? Flexible(
                        child: Text(
                          model.message!,
                          style: currentTextTheme(context).bodyLarge?.copyWith(
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
                          messageId: model.id!,
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
                                viewModel
                                    .translationModel.data!.message!.message!,
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
                ? model.sound.toString().contains("http") ||
                        context
                            .read<ConversationRoomViewModel>()
                            .soundUrl
                            .contains("http")
                    ? Selector<ImageUploadViewModel, File?>(
                        builder: (context, photo, child) {
                          return photo == null
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
                              : CircleAvatar(
                                  radius: 15.0,
                                  backgroundImage: FileImage(photo),
                                );
                        },
                        selector: (context, state) => state.uploadedImageUrl,
                      )
                    : Selector<ImageUploadViewModel, File?>(
                        builder: (context, photo, child) {
                          return photo == null
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
                              : CircleAvatar(
                                  radius: 15.0,
                                  backgroundImage: FileImage(photo),
                                );
                        },
                        selector: (context, state) => state.uploadedImageUrl,
                      )
                : const SizedBox(width: 0),
          ],
        ),
      ),
    );
  }
}
