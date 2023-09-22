// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/core/view/widget/button/profile_button.dart';
import 'package:talkios/product/profile/model/profile_model.dart';
import 'package:talkios/product/profile/profile_view_model.dart';
import 'package:talkios/product/profile/view/personal_information_view.dart';

import '../../../core/util/provider/image/image_upload_view_model.dart';

class ProfileView extends BaseStateless {
  final String name;
  final String profilePhoto;
  final ProfileModel profileModel;
  ProfileViewModel viewModel = ProfileViewModel();

  ProfileView({
    super.key,
    required this.name,
    required this.profilePhoto,
    required this.profileModel,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            image.background,
            fit: BoxFit.cover,
          ),
        ),
        profile(context),
      ],
    );
  }

  Padding profile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          spacer(height: 56.0),
          header(context),
          spacer(height: 40.0),
          buttons(context)
        ],
      ),
    );
  }

  Column buttons(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: viewModel.buttons.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Selector<ProfileViewModel, int>(
                builder: (context, buttonIndex, child) {
                  final heroTag = 'textHero$index';
                  return Hero(
                    tag: heroTag,
                    child: ProfileButton(
                      text: viewModel.buttons[index].text,
                      onPressed: () =>
                          context.read<ProfileViewModel>().handleButtonPressed(
                                context,
                                index,
                                viewModel.buttons[index].text,
                                profilePhoto: profilePhoto,
                                name: name,
                                profileModel: profileModel,
                              ),
                      profileIcon: viewModel.buttons[index].icon,
                      backgroundColor: buttonIndex == index
                          ? color.dark10
                          : Colors.transparent,
                    ),
                  );
                },
                selector: (context, state) => state.buttonIndex,
              ),
            );
          },
        ),
        ProfileButton(
          isLogout: true,
          text: "Log out",
          onPressed: () => viewModel.logOut(context),
          profileIcon: icon.accountSettings,
        ),
      ],
    );
  }

  Row header(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Material(
          type: MaterialType.transparency,
          child: IconButton(
            onPressed: () {
              HapticFeedback.heavyImpact();
              back(context);
            },
            icon: Icon(icon.arrowBack),
          ),
        ),
        Text(
          "Profile",
          style: currentTextTheme(context).bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: color.dark100,
                fontSize: 16.0,
                fontFamily: font.semiBold,
              ),
        ),
        Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {
              push(
                context,
                PersonalInformationView(
                  profileModel: profileModel,
                  profilePhoto: profilePhoto,
                  name: name,
                  pageTitle: "Personal Information",
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
                          backgroundImage:
                              CachedNetworkImageProvider(profilePhoto),
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
        ),
      ],
    );
  }
}
