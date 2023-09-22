// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/product/conversation/view/conversation_view.dart';
import 'package:talkios/product/home/home_view_model.dart';
import 'package:talkios/product/home/view/scenario_detail_view.dart';

import '../../../core/util/provider/image/image_upload_view_model.dart';
import '../../../core/view/widget/button/app_button.dart';
import '../../profile/view/profile_view.dart';

class HomeView extends BaseStateless {
  HomeViewModel viewModel = HomeViewModel();

  @override
  Widget build(BuildContext context) {
    return home();
  }

  Widget home() {
    return FutureBuilder(
      future: viewModel.getProfileAndScenarios(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingState(context);
        } else if (snapshot.connectionState == ConnectionState.done) {
          viewModel.controlUserInformation(context, viewModel.profileModel);

          return homeView(context);
        } else {
          return const Text("error");
        }
      },
    );
  }

  Container loadingState(BuildContext context) {
    return Container(
      width: width(context: context, value: 1.0),
      height: height(context: context, value: 1.0),
      color: color.background,
      child: Shimmer.fromColors(
        baseColor: color.dark10,
        highlightColor: color.dark30,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                spacer(height: 56.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 70.0,
                          height: 30.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: color.softPink,
                          ),
                        ),
                        spacer(width: 12.0),
                        Container(
                          width: 70.0,
                          height: 30.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: color.softYellow,
                          ),
                        ),
                      ],
                    ),
                    const CircleAvatar(
                      radius: 25.0,
                    ),
                  ],
                ),
                spacer(height: 46.0),
                SizedBox(
                  width: width(context: context, value: 1.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: width(context: context, value: 0.2),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 64.0),
                            child: SvgPicture.asset(
                              image.mapLine,
                            ),
                          ),
                        ),
                      ),
                      spacer(width: 24.0),
                      Expanded(
                        flex: 8,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          addAutomaticKeepAlives: false,
                          addRepaintBoundaries: false,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 15,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 28.0),
                              child: Container(
                                width: width(context: context, value: 0.8),
                                height: 128.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: color.background,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Scaffold homeView(BuildContext context) {
    return Scaffold(
      backgroundColor: color.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spacer(height: 56.0),
            header(context),
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: SizedBox(
                        width: width(context: context, value: 1.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: width(context: context, value: 0.2),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 64.0),
                                  child: SvgPicture.asset(
                                    image.mapLine,
                                  ),
                                ),
                              ),
                            ),
                            spacer(width: 24.0),
                            Expanded(
                              flex: 8,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                addAutomaticKeepAlives: false,
                                addRepaintBoundaries: false,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: viewModel.scenarios.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 28.0),
                                    child: scenarioButton(context, index),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 33.0,
                    right: 134.0,
                    left: 134.0,
                    child: Hero(
                      tag: "chat",
                      child: AppButton(
                        widthValue: width(context: context, value: 0.3),
                        heightValue: height(context: context, value: 0.07),
                        text: "Chat",
                        borderRadius: 66.0,
                        backgroundColor: color.dark100,
                        onPressed: () => push(
                          context,
                          ConversationView(
                            score: viewModel
                                .profileModel.data!.user!.userDetail!.score!,
                            userProfilePhoto: viewModel
                                .profileModel.data!.user!.profilePhoto!,
                          ),
                        ),
                        textStyle:
                            currentTextTheme(context).bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: color.background,
                                  fontSize: 14.0,
                                  fontFamily: font.bold,
                                ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget scenarioButton(BuildContext context, int index) {
    return Stack(
      children: [
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: viewModel.scenarios[index].isLocked == 0 ? 1.0 : 0.1,
          child: AbsorbPointer(
            absorbing: viewModel.scenarios[index].isLocked == 0 ? false : true,
            child: SizedBox(
              width: width(context: context, value: 0.8),
              height: 128.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: color.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: const BorderSide(
                      width: 1.0,
                      color: Color.fromRGBO(243, 243, 245, 1),
                    ),
                  ),
                ),
                onPressed: () {
                  push(
                    context,
                    ScenarioDetailView(
                      score:
                          viewModel.profileModel.data!.user!.userDetail!.score!,
                      scenarioName: viewModel.scenarios[index].title!,
                      level: "${index + 1}",
                      words: viewModel.scenarios[index].words!,
                      userProfilePhoto:
                          viewModel.profileModel.data!.user!.profilePhoto!,
                      aiProfilePhoto: viewModel.scenarios[index].photo!,
                      scenarioId: viewModel.scenarios[index].id!,
                      tagId: "aiProfilePhoto${viewModel.scenarios[index].id}",
                      subTitle: viewModel.scenarios[index].subTitle!,
                      scenarioDescription: viewModel.scenarios[index].scenario!,
                    ),
                  );
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Level ${index + 1}",
                            style:
                                currentTextTheme(context).bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: color.dark60,
                                      fontSize: 12.0,
                                      fontFamily: font.regular,
                                    ),
                          ),
                          spacer(height: 6.0),
                          Text(
                            viewModel.scenarios[index].title!,
                            style:
                                currentTextTheme(context).bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: color.dark100,
                                      fontSize: 16.0,
                                      fontFamily: font.semiBold,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    Hero(
                      tag: "aiProfilePhoto${viewModel.scenarios[index].id}",
                      child: Container(
                        width: 106.0,
                        height: 106.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                viewModel.scenarios[index].photo!),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(
                            6.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        viewModel.scenarios[index].isLocked == 0
            ? const Center()
            : Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(icon.lock),
                    spacer(height: 10.0),
                    Text(
                      "Complete level $index to unlock.",
                      style: currentTextTheme(context).bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: color.dark60,
                            fontSize: 14.0,
                            fontFamily: font.medium,
                          ),
                    )
                  ],
                ),
              ),
      ],
    );
  }

  Row header(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            headerChip(
              context,
              "1",
              icon.mission,
              color.pink.withOpacity(0.3),
              color.pink,
            ),
            spacer(width: 12.0),
            headerChip(
              context,
              viewModel.profileModel.data!.user!.userDetail!.score!.toString(),
              icon.star,
              color.yellow.withOpacity(0.3),
              color.yellow,
            ),
          ],
        ),
        InkWell(
          overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
          onTap: () {
            push(
              context,
              ProfileView(
                profileModel: viewModel.profileModel,
                profilePhoto: viewModel.profileModel.data!.user!.profilePhoto!,
                name: viewModel.profileModel.data!.user!.name!,
              ),
            );
          },
          child: Selector<ImageUploadViewModel, File?>(
            builder: (context, photo, child) {
              return Hero(
                tag: "profilePhoto",
                child: photo == null
                    ? CircleAvatar(
                        radius: 20.0,
                        backgroundImage: CachedNetworkImageProvider(
                            viewModel.profileModel.data!.user!.profilePhoto!),
                      )
                    : CircleAvatar(
                        radius: 20.0,
                        backgroundImage: FileImage(photo),
                      ),
              );
            },
            selector: (context, state) => state.uploadedImageUrl,
          ),
        ),
      ],
    );
  }

  Chip headerChip(
    BuildContext context,
    String text,
    String icon,
    Color backgroundColor,
    Color itemColor,
  ) {
    return Chip(
      padding: const EdgeInsets.all(8.0),
      backgroundColor: backgroundColor,
      avatar: SvgPicture.asset(
        icon,
        color: itemColor,
      ),
      label: Text(
        text,
        style: currentTextTheme(context).bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: itemColor,
              fontSize: 14.0,
              fontFamily: font.extraBold,
            ),
      ),
    );
  }
}
