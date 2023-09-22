// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/core/view/widget/button/app_button.dart';
import 'package:talkios/product/conversation/view/conversation_room_view.dart';
import 'package:talkios/product/conversation/viewmodel/conversation_view_model.dart';
import 'package:talkios/product/home/view/home_view.dart';

class ConversationView extends BaseStateless {
  ConversationViewModel viewModel = ConversationViewModel();
  final String userProfilePhoto;
  final int score;

  ConversationView({
    super.key,
    required this.userProfilePhoto,
    required this.score,
  });
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: viewModel.getAllConversation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingState(context);
        } else if (snapshot.connectionState == ConnectionState.done) {
          return conversation(context);
        } else {
          return const Text("Error");
        }
      },
    );
  }

  Stack loadingState(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            image.background,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 33.0),
          child: Shimmer.fromColors(
            baseColor: color.dark10,
            highlightColor: color.dark30,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                spacer(height: 56.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Material(
                      type: MaterialType.transparency,
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(icon.arrowBack),
                      ),
                    ),
                    Text(
                      "Chat",
                      style: currentTextTheme(context).bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: color.dark100,
                            fontSize: 18.0,
                            fontFamily: font.semiBold,
                          ),
                    ),
                    const SizedBox(width: 44.0),
                  ],
                ),
                spacer(height: 54.0),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: 10,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Container(
                        width: width(context: context, value: 1.0),
                        height: 90.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: color.background,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Stack conversation(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            image.background,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 33.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              spacer(height: 56.0),
              header(context),
              viewModel.conversations.isNotEmpty
                  ? conversationList()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Lottie.asset(lottie.emptyState),
                        Text(
                          "Hey, it's pretty quiet in here... maybe you'd like to say 'Hello'?",
                          style: currentTextTheme(context).bodyLarge?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: color.dark70,
                                fontSize: 18.0,
                                fontFamily: font.regular,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        spacer(height: 30.0),
                        AppButton(
                          widthValue: width(context: context, value: 0.5),
                          heightValue: height(context: context, value: 0.07),
                          text: "Browse Scenarios",
                          borderRadius: 66.0,
                          backgroundColor: color.dark100,
                          onPressed: () => back(context),
                          textStyle:
                              currentTextTheme(context).bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: color.background,
                                    fontSize: 16.0,
                                    fontFamily: font.regular,
                                  ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Expanded conversationList() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: ListView.builder(
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          padding: EdgeInsets.zero,
          physics: const ClampingScrollPhysics(),
          itemCount: viewModel.conversations.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: color.background,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    )),
                onPressed: () {
                  push(
                    context,
                    ConversationRoomView(
                        score: score,
                        scenarioName:
                            viewModel.conversations[index].scenario!.title!,
                        aiProfilePhoto:
                            viewModel.conversations[index].scenario!.icon!,
                        userProfilePhoto: userProfilePhoto,
                        conversationId: viewModel.conversations[index].id!),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 35.0,
                            backgroundImage: CachedNetworkImageProvider(
                              viewModel.conversations[index].scenario!.icon!,
                            ),
                          ),
                          spacer(width: 15.0),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                viewModel.conversations[index].scenario!.title!,
                                style: currentTextTheme(context)
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: color.dark100,
                                      fontSize: 16.0,
                                      fontFamily: font.medium,
                                    ),
                              ),
                              spacer(height: 3.0),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 106.0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: LinearProgressIndicator(
                                        minHeight: 16.0,
                                        value: double.parse(viewModel
                                            .conversations[index]
                                            .conversationCompletionCount!),
                                        backgroundColor: const Color.fromRGBO(
                                            36, 39, 47, 0.1),
                                        valueColor:
                                            AlwaysStoppedAnimation(color.cyan),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 10.0,
                                    child: Text(
                                      "%${(double.parse(viewModel.conversations[index].conversationCompletionCount!) * 100).toInt()}",
                                      style: currentTextTheme(context)
                                          .bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: color.background,
                                            fontSize: 12.0,
                                            fontFamily: font.regular,
                                          ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => push(
                          context,
                          ConversationRoomView(
                              score: score,
                              scenarioName: viewModel
                                  .conversations[index].scenario!.title!,
                              aiProfilePhoto: viewModel
                                  .conversations[index].scenario!.icon!,
                              userProfilePhoto: userProfilePhoto,
                              conversationId:
                                  viewModel.conversations[index].id!),
                        ),
                        icon: Icon(icon.arrowForward),
                        color: color.dark100,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Row header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Material(
          type: MaterialType.transparency,
          child: IconButton(
            onPressed: () {
              HapticFeedback.heavyImpact();
              push(context, HomeView());
            },
            icon: Icon(icon.arrowBack),
          ),
        ),
        Hero(
          tag: "chat",
          child: Text(
            "Chat",
            style: currentTextTheme(context).bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color.dark100,
                  fontSize: 18.0,
                  fontFamily: font.semiBold,
                ),
          ),
        ),
        const SizedBox(width: 44.0),
      ],
    );
  }
}
