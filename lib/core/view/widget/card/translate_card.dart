// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../product/conversation/viewmodel/conversation_room_view_model.dart';
import '../../../util/provider/chat_tools_provider.dart';
import '../../base/base_state.dart';

class TranslateCard extends StatefulWidget {
  ConversationRoomViewModel viewModel;
  int conversationId;
  int messageId;
  TranslateCard({
    Key? key,
    required this.viewModel,
    required this.conversationId,
    required this.messageId,
  }) : super(key: key);

  @override
  State<TranslateCard> createState() => _TranslateCardState();
}

class _TranslateCardState extends BaseState<TranslateCard> {
  late Future apiFuture;
  @override
  void initState() {
    super.initState();
    apiFuture = widget.viewModel.translate(
      conversationId: widget.conversationId,
      messageId: widget.messageId,
    );
  }

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
                FutureBuilder(
                    future: apiFuture,
                    builder: (contxt, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Lottie.asset(
                          lottie.loadingMessage,
                          width: 32.0,
                          height: 32.0,
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        if (widget.viewModel.translationModel.data != null) {
                          if (widget.viewModel.translationModel.data!.message !=
                              null) {
                            if (widget.viewModel.translationModel.data!.message!
                                        .message !=
                                    null &&
                                widget.viewModel.translationModel.data!.message!
                                    .message!.isNotEmpty) {
                              return Text(
                                widget.viewModel.translationModel.data!.message!
                                    .message!,
                                style: currentTextTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: color.dark100,
                                  fontSize: 12.0,
                                  fontFamily: font.regular,
                                ),
                              );
                            } else {
                              return Lottie.asset(
                                lottie.loadingMessage,
                                width: 32.0,
                                height: 32.0,
                              );
                            }
                          } else {
                            return Lottie.asset(
                              lottie.loadingMessage,
                              width: 32.0,
                              height: 32.0,
                            );
                          }
                        } else {
                          return Lottie.asset(
                            lottie.loadingMessage,
                            width: 32.0,
                            height: 32.0,
                          );
                        }
                      } else {
                        return const Text("error");
                      }
                    })
              ],
            ),
          ),
          Positioned(
            top: 0.0,
            right: 0.0,
            child: IconButton(
              splashColor: Colors.transparent,
              padding: EdgeInsets.zero,
              onPressed: () {
                context.read<ChatToolsProvider>().isTranslate = false;
              },
              iconSize: 16.0,
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
