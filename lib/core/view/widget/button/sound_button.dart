// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:talkios/core/view/base/base_stateless.dart';

class SoundButton extends BaseStateless {
  String profilePhoto;
  void Function() onPressed;
  Color borderColor;
  SoundButton({
    super.key,
    required this.profilePhoto,
    required this.onPressed,
    required this.borderColor,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 91.0,
      height: 51.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color.dark20,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(
              color: borderColor,
              width: 1.0,
            ),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 40.0,
                height: 40.0,
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundImage: CachedNetworkImageProvider(profilePhoto),
                ),
              ),
              SvgPicture.asset(
                icon.speak,
                width: 40.0,
                height: 40.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
