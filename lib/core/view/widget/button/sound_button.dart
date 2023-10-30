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
      height: 31.0,
      width: 51.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(153, 187, 246, 0.4),
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: 28.0,
                height: 30.0,
                child: profilePhoto == icon.appIcon
                    ? CircleAvatar(
                        radius: 20.0,
                        backgroundImage: AssetImage(icon.appIcon),
                      )
                    : CircleAvatar(
                        radius: 20.0,
                        backgroundImage:
                            CachedNetworkImageProvider(profilePhoto),
                      ),
              ),
            ),
            Expanded(
              child: SvgPicture.asset(
                icon.speak,
                width: 25.0,
                height: 25.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
