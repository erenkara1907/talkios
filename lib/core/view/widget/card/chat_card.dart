// ignore_for_file: no_leading_underscores_for_local_identifiers, must_be_immutable, use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/util/provider/image/image_upload_view_model.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/core/view/widget/progress/circle_bubble_progress.dart';
import 'package:talkios/product/conversation/viewmodel/conversation_room_view_model.dart';

import '../../../../product/conversation/model/chat_model.dart';
import '../../../util/provider/sound/dubbing_provider.dart';
import '../button/practice_button.dart';
import '../button/sound_button.dart';
import '../progress/circle_progress.dart';

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
    required this.scaffoldKey,
  });

  AudioPlayer player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: model.role == "user"
          ? () {
              if (model.sound.toString().contains("http") ||
                  context
                      .read<ConversationRoomViewModel>()
                      .soundUrl
                      .contains("http")) {
                if (model.score != 0 && model.score != null) {
                  context
                      .read<ConversationRoomViewModel>()
                      .updateScore(model.score.toString());
                }

                dubbingProvider.stop();
                context.read<DubbingProvider>().stop();
                context.read<ConversationRoomViewModel>().addSoundUrl(
                    context.read<ConversationRoomViewModel>().soundUrl);
                HapticFeedback.heavyImpact();
                pronunciationBottomSheet(
                  model.message!,
                  aiProfilePhoto,
                  userProfilePhoto,
                );
              }
            }
          : () {},
      child: Align(
        alignment:
            model.role == "user" ? Alignment.topRight : Alignment.topLeft,
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
                    topRight:
                        Radius.circular(model.role == "user" ? 0.0 : 20.0),
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
                                    model.message!,
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
                          ? model.sound.toString().contains("http") ||
                                  context
                                      .read<ConversationRoomViewModel>()
                                      .soundUrl
                                      .contains("http")
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Selector<ImageUploadViewModel, File?>(
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
                                                    placeholder: (context,
                                                            url) =>
                                                        const CircularProgressIndicator(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                ),
                                              )
                                            : CircleAvatar(
                                                radius: 15.0,
                                                backgroundImage:
                                                    FileImage(photo),
                                              );
                                      },
                                      selector: (context, state) =>
                                          state.uploadedImageUrl,
                                    ),
                                    spacer(height: 12.0),
                                    model.score == null || model.score == 0
                                        ? const Center()
                                        : CircleBubbleProgress(
                                            score: model.score.toString(),
                                            lineWidth: 2.0,
                                            viewModel: viewModel,
                                            circleRadius: 15.0,
                                            textFontSize: 10.0,
                                          )
                                  ],
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
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                          )
                                        : CircleAvatar(
                                            radius: 15.0,
                                            backgroundImage: FileImage(photo),
                                          );
                                  },
                                  selector: (context, state) =>
                                      state.uploadedImageUrl,
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
                                    _provider.speak(model.message!, index);
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
                                      ConversationRoomViewModel provider =
                                          context.read<
                                              ConversationRoomViewModel>();

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
      ),
    );
  }

  void pronunciationBottomSheet(
    String message,
    String aiProfilePhoto,
    String userProfilePhoto,
  ) {
    final Completer<void> _completer = Completer();
    showModalBottomSheet(
      context: scaffoldKey.currentContext!,
      builder: (BuildContext context) {
        if ((!_completer.isCompleted && model.score == 0) ||
            model.score == null) {
          context
              .read<ConversationRoomViewModel>()
              .pronunciationCheck(
                true,
                conversationId,
                messageId,
                context,
                message,
                model.sound ??
                    context.read<ConversationRoomViewModel>().soundUrl,
                chats,
              )
              .then((value) => _completer
                  .complete()); // Future tamamlandığında completer'ı tamamlıyoruz.
        }
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: FractionallySizedBox(
            heightFactor: 0.6, // Ekranın %60'ını kaplaması için
            child: Container(
              decoration: BoxDecoration(
                color: color.background.withOpacity(0.8),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ), // İstediğiniz bir renk olabilir.
              child: model.score == 0 || model.score == null
                  ? notScore(
                      _completer, message, aiProfilePhoto, userProfilePhoto)
                  : pronunciation(
                      message, aiProfilePhoto, userProfilePhoto, context),
            ),
          ),
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20), // Üst köşeleri yuvarlatma
        ),
      ),
      isScrollControlled:
          true, // Ekranın boyutuna göre modalın boyutunu ayarlamak için
    ).then((value) async {
      scaffoldKey.currentContext!
          .read<ConversationRoomViewModel>()
          .updateScore("0");
    });
  }

  FutureBuilder<void> notScore(Completer<void> _completer, String message,
      String aiProfilePhoto, String userProfilePhoto) {
    return FutureBuilder(
      future: _completer.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Lottie.asset(lottie.pronunciationLoading),
          );
        } else if (snapshot.connectionState == ConnectionState.done) {
          return pronunciation(message, aiProfilePhoto, userProfilePhoto,
              scaffoldKey.currentContext!);
        } else {
          return const Text("Error");
        }
      },
    );
  }

  Column pronunciation(
    String message,
    String aiProfilePhoto,
    String userProfilePhoto,
    BuildContext context,
  ) {
    return Column(
      children: [
        const Expanded(child: SizedBox()),
        Selector<ConversationRoomViewModel, bool>(
          builder: (context, isLoading, child) {
            return isLoading
                ? SizedBox(
                    width: 82.0,
                    height: 82.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 5.0,
                      color: color.dark100,
                      backgroundColor: color.dark50,
                    ),
                  )
                : CircleProgress(
                    score:
                        context.read<ConversationRoomViewModel>().score.isEmpty
                            ? model.score.toString()
                            : context
                                .read<ConversationRoomViewModel>()
                                .score
                                .toString(),
                    viewModel: viewModel,
                  );
          },
          selector: (context, state) => state.isPracticeLoading,
        ),
        const SizedBox(height: 2.0),
        Selector<ConversationRoomViewModel, String>(
          builder: (context, score, child) {
            return Text(
              viewModel.getScoreStatus(
                int.parse(score.isNotEmpty
                    ? score
                    : model.score!.toString().isNotEmpty && model.score != null
                        ? model.score.toString()
                        : "0"),
              ),
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: viewModel.getScoreColor(
                    int.parse(score.isNotEmpty
                        ? score
                        : model.score.toString().isNotEmpty && model.score != null
                            ? model.score.toString()
                            : "0"),
                  ),
                  fontSize: 20.0,
                  fontFamily: font.semiBold),
            );
          },
          selector: (context, state) => state.score,
        ),
        const SizedBox(height: 32.0),
        Text(
          message,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: color.dark100,
            fontSize: 16.0,
            fontFamily: font.semiBold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 21.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Selector<ConversationRoomViewModel, bool>(
              builder: (context, isAI, child) {
                return SoundButton(
                  borderColor: isAI ? color.background : Colors.transparent,
                  onPressed: () async {
                    await player.stop();
                    context.read<ConversationRoomViewModel>().tapAIVoice();
                    dubbingProvider.speak(message, index);
                  },
                  profilePhoto: aiProfilePhoto,
                );
              },
              selector: (context, state) => state.isTapAIVoice,
            ),
            const SizedBox(width: 20.0),
            Selector<ConversationRoomViewModel, bool>(
              builder: (context, isUser, child) {
                return SoundButton(
                  borderColor: isUser ? color.background : Colors.transparent,
                  onPressed: () async {
                    dubbingProvider.stop();
                    context.read<ConversationRoomViewModel>().tapUserVoice();
                    await player.play(UrlSource(model.sound ??
                        context.read<ConversationRoomViewModel>().soundUrl));
                  },
                  profilePhoto: userProfilePhoto,
                );
              },
              selector: (context, state) => state.isTapUserVoice,
            ),
          ],
        ),
        const SizedBox(height: 38.0),
        PracticeButton(
          chats: chats,
          conversationId: conversationId,
          messageId: messageId,
          viewModel: viewModel,
          message: message,
          dubbingProvider: dubbingProvider,
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
