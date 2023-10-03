// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/view/base/base_stateless.dart';

import '../../../core/util/provider/image/image_upload_view_model.dart';
import '../model/profile_model.dart';
import '../profile_view_model.dart';

class PersonalInformationView extends BaseStateless {
  final String profilePhoto;
  final String name;
  final String pageTitle;
  final ProfileModel profileModel;
  const PersonalInformationView({
    super.key,
    required this.profilePhoto,
    required this.name,
    required this.pageTitle,
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
        personalInformation(context),
      ],
    );
  }

  Stack personalInformation(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              spacer(height: 56.0),
              header(context),
              Material(
                type: MaterialType.transparency,
                child: InkWell(
                  overlayColor:
                      MaterialStateProperty.all<Color?>(Colors.transparent),
                  onTap: () {
                    context.read<ProfileViewModel>().showModal(true);
                    context.read<ProfileViewModel>().showEditProfile(
                          context,
                          profilePhoto,
                          name,
                          context.read<ProfileViewModel>().nameController,
                        );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Image",
                        style: currentTextTheme(context).bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: color.dark100,
                              fontSize: 14.0,
                              fontFamily: font.medium,
                            ),
                      ),
                      Selector<ImageUploadViewModel, File?>(
                        builder: (context, photo, child) {
                          return Hero(
                            tag: "profilePhoto",
                            child: photo == null
                                ? CircleAvatar(
                                    radius: 20.0,
                                    backgroundImage: CachedNetworkImageProvider(
                                        profilePhoto),
                                  )
                                : CircleAvatar(
                                    radius: 20.0,
                                    backgroundImage: FileImage(photo),
                                  ),
                          );
                        },
                        selector: (context, state) => state.uploadedImageUrl,
                      ),
                    ],
                  ),
                ),
              ),
              spacer(height: 20.0),
              Material(
                type: MaterialType.transparency,
                child: InkWell(
                  overlayColor:
                      MaterialStateProperty.all<Color?>(Colors.transparent),
                  onTap: () {
                    context.read<ProfileViewModel>().setName(name);
                    context.read<ProfileViewModel>().showModal(false);
                    context.read<ProfileViewModel>().showEditProfile(
                          context,
                          profilePhoto,
                          name,
                          context.read<ProfileViewModel>().nameController,
                        );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Name",
                        style: currentTextTheme(context).bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: color.dark100,
                              fontSize: 14.0,
                              fontFamily: font.medium,
                            ),
                      ),
                      Selector<ProfileViewModel, String>(
                        builder: (context, nameState, child) {
                          return Hero(
                            tag: "username",
                            child: Text(
                              nameState.isNotEmpty ? nameState : name,
                              style:
                                  currentTextTheme(context).bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: color.cyan,
                                        fontSize: 14.0,
                                        fontFamily: font.medium,
                                      ),
                            ),
                          );
                        },
                        selector: (context, state) => state.nameController.text,
                      ),
                    ],
                  ),
                ),
              ),
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
        Material(
          type: MaterialType.transparency,
          child: IconButton(
            onPressed: () {
              context.read<ProfileViewModel>().handleButtonPressed(
                    context,
                    -1,
                    pageTitle,
                    profileModel: profileModel,
                  );
              HapticFeedback.heavyImpact();
              back(context);
            },
            icon: Icon(icon.arrowBack),
          ),
        ),
        Hero(
          tag: 'textHero0',
          child: Text(
            pageTitle,
            style: currentTextTheme(context).bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color.dark100,
                  fontSize: 16.0,
                  fontFamily: font.semiBold,
                ),
          ),
        ),
        const SizedBox(width: 24.0),
      ],
    );
  }
}
