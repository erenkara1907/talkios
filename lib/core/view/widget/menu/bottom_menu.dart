// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    super.initState();
    taskFuture = widget.viewModel.getTasks(widget.conversationId);
    clueFuture = widget.viewModel.suggestResponse(widget.conversationId);
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MenuCard(
                    borderColor:
                        state.isOpenTasks ? color.dark100 : Colors.transparent,
                    model: state.menuCards[0],
                    onTap: () {
                      taskFuture =
                          widget.viewModel.getTasks(widget.conversationId);

                      if (state.isOpenTasks) {
                        state.openTask(false);
                      } else {
                        state.openClue(false);
                        state.openTask(true);
                      }
                    },
                  ),
                  MenuCard(
                    borderColor:
                        state.isOpenClue ? color.dark100 : Colors.transparent,
                    model: state.menuCards[1],
                    onTap: () {
                      clueFuture = widget.viewModel
                          .suggestResponse(widget.conversationId);
                      if (state.isOpenClue) {
                        state.openClue(false);
                      } else {
                        state.openTask(false);
                        state.openClue(true);
                      }
                    },
                  ),
                ],
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
                                return task(
                                  context,
                                  model.title!,
                                  index,
                                  model.isComplete!
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  widget.viewModel.taskModel.data!.conversation!
                                      .words!.length,
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
                      ? const Center()
                      : futureSuggest()
            ],
          ),
        );
      },
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
            return Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Align(
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
                "($taskLength/4)",
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
