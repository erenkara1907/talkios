import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:talkios/core/view/base/base_stateless.dart';

import '../../../../product/conversation/model/chat_model.dart';

class ChatCard extends BaseStateless {
  final int index;
  final ChatModel model;
  final String userProfilePhoto;
  final String aiProfilePhoto;

  const ChatCard({
    super.key,
    required this.index,
    required this.model,
    required this.userProfilePhoto,
    required this.aiProfilePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: model.role == "user" ? Alignment.topRight : Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Container(
          constraints: BoxConstraints(
            maxWidth:
                MediaQuery.of(context).size.width * 0.7, // Maksimum genişlik
          ),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(243, 243, 245, 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(model.role == "user" ? 20.0 : 0.0),
              bottomLeft: const Radius.circular(20.0),
              bottomRight: const Radius.circular(20.0),
              topRight: Radius.circular(model.role == "user" ? 0.0 : 20.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 21.0,
              horizontal: 10.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                model.role != "user"
                    ? CircleAvatar(
                        radius: 15.0,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: aiProfilePhoto,
                            fit: BoxFit.cover,
                            width: 30.0, // 2 * radius
                            height: 30.0, // 2 * radius
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      )
                    : const SizedBox(width: 0),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    model.message,
                    style: currentTextTheme(context).bodyLarge?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: color.dark100,
                          fontSize: 14.0,
                          fontFamily: font.regular,
                        ),
                  ),
                ),
                const SizedBox(width: 10),
                model.role == "user"
                    ? CircleAvatar(
                        radius: 15.0,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: userProfilePhoto,
                            fit: BoxFit.cover,
                            width: 30.0, // 2 * radius
                            height: 30.0, // 2 * radius
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      )
                    : const SizedBox(width: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
