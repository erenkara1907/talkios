// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/util/provider/translate_provider.dart';
import 'package:talkios/core/view/base/base_state.dart';

import '../../../../product/conversation/model/task_model.dart';
import '../../../../product/conversation/viewmodel/bottom_menu_view_model.dart';
import '../../../../product/conversation/viewmodel/conversation_room_view_model.dart';
import '../card/menu_card.dart';

class BottomMenu extends StatefulWidget {
  int conversationId;
  ConversationRoomViewModel viewModel;

  BottomMenu({
    super.key,
    required this.conversationId,
    required this.viewModel,
  });

  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends BaseState<BottomMenu> {
  late Future<void> taskFuture;
  late Future<void> clueFuture;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    taskFuture = widget.viewModel.getTasks(widget.conversationId);
    clueFuture = widget.viewModel.suggestResponse(widget.conversationId);
    context
        .read<BottomMenuViewModel>()
        .nativeController
        .addListener(_onTextChanged);
  }

  @override
  void dispose() {
    context.read<BottomMenuViewModel>().nativeController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  _onTextChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(seconds: 1), () {
      // Kullanıcı yazmayı bıraktıktan 1s sonra burası çalışacak
      if (context
          .read<BottomMenuViewModel>()
          .nativeController
          .text
          .isNotEmpty) {
        context.read<TranslateProvider>().isTapTranslate = true;
      } else {
        context.read<BottomMenuViewModel>().translateController.clear();

        context.read<TranslateProvider>().isTapTranslate = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomMenuViewModel>(
      builder: (context, state, child) {
        return AnimatedPadding(
          duration: const Duration(milliseconds: 600),
          padding: const EdgeInsets.only(
            left: 18.0,
            right: 18.0,
          ),
          child: Column(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.zero,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  height: height(0.08),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      MenuCard(
                        borderColor: state.isOpenTasks
                            ? color.dark100
                            : Colors.transparent,
                        model: state.menuCards[0],
                        onTap: () {
                          taskFuture =
                              widget.viewModel.getTasks(widget.conversationId);

                          context.read<BottomMenuViewModel>().isCopied = false;

                          if (state.isOpenTasks) {
                            state.openTask(false);
                          } else {
                            state.isOpenTranslate = false;
                            state.openClue(false);
                            state.openTask(true);
                          }
                        },
                      ),
                      MenuCard(
                        borderColor: state.isOpenClue
                            ? color.dark100
                            : Colors.transparent,
                        model: state.menuCards[1],
                        onTap: () {
                          clueFuture = widget.viewModel
                              .suggestResponse(widget.conversationId);

                          context.read<BottomMenuViewModel>().isCopied = false;

                          if (state.isOpenClue) {
                            state.openClue(false);
                          } else {
                            state.isOpenTranslate = false;
                            state.openTask(false);
                            state.openClue(true);
                          }
                        },
                      ),
                      MenuCard(
                        borderColor: state.isOpenTranslate
                            ? color.dark100
                            : Colors.transparent,
                        model: state.menuCards[2],
                        onTap: () {
                          context.read<BottomMenuViewModel>().isCopied = false;
                          if (state.isOpenTranslate) {
                            state.isOpenTranslate = false;
                          } else {
                            state.openTask(false);
                            state.openClue(false);
                            state.isOpenTranslate = true;
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              state.isOpenTasks
                  ? FutureBuilder(
                      future: taskFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                              itemCount: widget.viewModel.taskModel.data!
                                  .conversation!.completedTasks!.length,
                              itemBuilder: (context, index) {
                                CompletedTask model = widget.viewModel.taskModel
                                    .data!.conversation!.completedTasks![index];
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: index ==
                                            widget
                                                    .viewModel
                                                    .taskModel
                                                    .data!
                                                    .conversation!
                                                    .completedTasks!
                                                    .length -
                                                1
                                        ? 0.0
                                        : 10.0,
                                  ),
                                  child: task(
                                    context,
                                    model.title!,
                                    index,
                                    model.isComplete!
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    widget.viewModel.taskModel.data!
                                        .conversation!.words!.length,
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return const Text("Error");
                        }
                      },
                    )
                  : !state.isOpenClue
                      ? state.isOpenTranslate
                          ? Column(
                              children: [
                                translateField(
                                  controller: state.nativeController,
                                  focusNode: state.nativeFocusNode,
                                  isTranslateField: false,
                                  flag: state.getLanguageIcon(),
                                  hintText: "Write something",
                                  iconOnPress: () =>
                                      state.nativeController.clear(),
                                ),
                                spacer(height: 5.0),
                                Selector<TranslateProvider, bool>(
                                  builder: (ctx, isTap, child) {
                                    return isTap
                                        ? FutureBuilder(
                                            future: context
                                                .read<TranslateProvider>()
                                                .translate(
                                                  text: state
                                                      .nativeController.text,
                                                  language: "english",
                                                ),
                                            builder: (ctx, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return translateField(
                                                  controller:
                                                      state.translateController,
                                                  isTranslateField: true,
                                                  flag: icon.englandFlag,
                                                  hintText:
                                                      "Loading translated message..",
                                                  iconOnPress: () {
                                                    state.clipToClipboard(state
                                                        .translateController
                                                        .text);
                                                  },
                                                );
                                              } else if (snapshot
                                                      .connectionState ==
                                                  ConnectionState.done) {
                                                state.translateController.text =
                                                    context
                                                        .read<
                                                            TranslateProvider>()
                                                        .translatedText;
                                                return translateField(
                                                  controller:
                                                      state.translateController,
                                                  isTranslateField: true,
                                                  flag: icon.englandFlag,
                                                  hintText: "See translation",
                                                  iconOnPress: () {
                                                    state.clipToClipboard(state
                                                        .translateController
                                                        .text);
                                                  },
                                                );
                                              } else {
                                                return translateField(
                                                  controller:
                                                      state.translateController,
                                                  isTranslateField: true,
                                                  flag: icon.englandFlag,
                                                  hintText: "Please try again",
                                                  iconOnPress: () {
                                                    state.clipToClipboard(state
                                                        .translateController
                                                        .text);
                                                  },
                                                );
                                              }
                                            },
                                          )
                                        : translateField(
                                            controller:
                                                state.translateController,
                                            isTranslateField: true,
                                            flag: icon.englandFlag,
                                            hintText: "See translation",
                                            iconOnPress: () {
                                              state.clipToClipboard(state
                                                  .translateController.text);
                                            },
                                          );
                                  },
                                  selector: (context, translate) =>
                                      translate.isTapTranslate,
                                ),
                              ],
                            )
                          : const Center()
                      : futureSuggest()
            ],
          ),
        );
      },
    );
  }

  SizedBox translateField({
    required String flag,
    required String hintText,
    required bool isTranslateField,
    required TextEditingController controller,
    required void Function() iconOnPress,
    FocusNode? focusNode,
  }) {
    return SizedBox(
      width: width(1.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: SvgPicture.asset(
              flag,
              width: 32.0,
              height: 32.0,
            ),
          ),
          spacer(width: 16.0),
          Stack(
            children: [
              SizedBox(
                width: width(
                    0.75), // Not: `width` fonksiyonunuzun ne yaptığını bilmiyorum, bu satır kodunuzda olmayabilir.
                child: SingleChildScrollView(
                  reverse: true, // içerik doldukça aşağı doğru kaydırma
                  child: TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    enabled: isTranslateField ? false : true,
                    style: currentTextTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: color.dark100,
                      fontSize: 16.0,
                      fontFamily: font.regular,
                    ),
                    cursorColor: color.dark80,
                    maxLines: null, // çok satırlı girişe izin ver
                    keyboardType: TextInputType
                        .multiline, // klavye tipini çok satırlı yap
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(right: 30.0),
                      hintText: hintText,
                      hintStyle: currentTextTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: color.dark50,
                        fontSize: 16.0,
                        fontFamily: font.regular,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: color.dark100),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0.0,
                top: 0.0,
                bottom: 0.0,
                child: IconButton(
                  onPressed: iconOnPress,
                  icon: isTranslateField
                      ? Selector<BottomMenuViewModel, bool>(
                          builder: (ctx, isCopy, child) {
                            return Icon(
                              Icons.copy,
                              color: isCopy ? color.softGreen : color.dark50,
                            );
                          },
                          selector: (context, state) => state.isCopied,
                        )
                      : SvgPicture.asset(icon.close),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  FutureBuilder<dynamic> futureSuggest() {
    return FutureBuilder(
        future: clueFuture,
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
            return Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  context.read<ConversationRoomViewModel>().changeAskText(
                      widget.viewModel.suggestModel.data!.suggestResponse!);
                },
                child: Text(
                  widget.viewModel.suggestModel.data!.suggestResponse!,
                  style: currentTextTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: color.dark100,
                    fontSize: 14.0,
                    fontFamily: font.regular,
                  ),
                ),
              ),
            );
          } else {
            return const Text("error");
          }
        });
  }

  Row task(BuildContext context, String task, int index,
      TextDecoration decoration, int taskLength) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "●  ",
          style: currentTextTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w400,
            color: color.dark10,
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
                " ($taskLength/4)",
                style: currentTextTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color.dark100,
                  fontSize: 14.0,
                  fontFamily: font.bold,
                  decoration: taskLength == 4
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              )
            : index == 0
                ? Text(
                    " (10 Message)",
                    style: currentTextTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color.dark100,
                      fontSize: 14.0,
                      fontFamily: font.bold,
                      decoration: taskLength == 4
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  )
                : const Center()
      ],
    );
  }
}
