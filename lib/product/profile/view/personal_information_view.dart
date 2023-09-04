import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/view/base/base_stateless.dart';

import '../profile_view_model.dart';

class PersonalInformationView extends BaseStateless {
  final String profilePhoto;
  final String name;
  final String pageTitle;
  const PersonalInformationView({
    super.key,
    required this.profilePhoto,
    required this.name,
    required this.pageTitle,
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

  Padding personalInformation(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          spacer(height: 56.0),
          header(context),
          Row(
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
              Hero(
                tag: "profilePhoto",
                child: CircleAvatar(
                    radius: 20.0,
                    backgroundImage: CachedNetworkImageProvider(profilePhoto)),
              ),
            ],
          ),
          spacer(height: 20.0),
          Row(
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
              Text(
                name,
                style: currentTextTheme(context).bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: color.cyan,
                      fontSize: 14.0,
                      fontFamily: font.medium,
                    ),
              ),
            ],
          ),
        ],
      ),
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
              context
                  .read<ProfileViewModel>()
                  .handleButtonPressed(context, -1, pageTitle);
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
