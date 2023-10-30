// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../util/provider/chat_tools_provider.dart';
import '../../base/base_stateless.dart';

class TipCard extends BaseStateless {
  String betterSentence;
  TipCard({
    super.key,
    required this.betterSentence,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width(context: context, value: 0.7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: const Color.fromRGBO(157, 157, 233, 0.1),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                spacer(height: 24.0),
                Text(
                  betterSentence,
                  style: currentTextTheme(context).bodyLarge?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: color.dark100,
                        fontSize: 12.0,
                        fontFamily: font.regular,
                      ),
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  maxLines: null,
                ),
              ],
            ),
          ),
          Positioned(
            top: 0.0,
            right: 0.0,
            child: IconButton(
              onPressed: () {
                context.read<ChatToolsProvider>().isTip = false;
              },
              icon: const Icon(
                Icons.close,
                size: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
