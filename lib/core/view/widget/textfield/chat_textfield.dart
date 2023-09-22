import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/product/conversation/viewmodel/conversation_room_view_model.dart';

import '../../../util/provider/sound/dubbing_provider.dart';

class ChatTextField extends BaseStateless {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  const ChatTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: TextFormField(
          onTap: () {
            context.read<DubbingProvider>().stop(); // Stop Dubbing
            context
                .read<ConversationRoomViewModel>()
                .sendAutomaticMessage(false);
          },
          onChanged: (value) {
            if (value.isNotEmpty) {
              context
                  .read<ConversationRoomViewModel>()
                  .changeEmptyTextStatus(false);
            } else {
              context
                  .read<ConversationRoomViewModel>()
                  .changeEmptyTextStatus(true);
            }
          },
          maxLines: null,
          controller: controller,
          focusNode: focusNode,
          style: currentTextTheme(context).bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: color.dark100,
                fontSize: 16.0,
                fontFamily: font.regular,
              ),
          cursorColor: color.dark100,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(
              left: 70.0,
              top: 20.0,
              bottom: 20.0,
              right: 60.0,
            ),
            hintText: hintText,
            hintStyle: currentTextTheme(context).bodyLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: color.dark20,
                  fontSize: 16.0,
                  fontFamily: font.regular,
                ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
              borderSide: BorderSide(
                width: 1.0,
                color: color.dark10,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.0),
              borderSide: BorderSide(
                width: 1.0,
                color: color.dark10,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
