import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/view/base/base_stateless.dart';

import '../../../product/auth/register/register_view_model.dart';

class InterestedView extends BaseStateless {
  final PageController pageController;
  InterestedView({
    super.key,
    required this.pageController,
  });
  final List<String> items = [
    "Game",
    "Fashion",
    "Sport",
    "Languages",
    "Animals",
    "Shopping",
    "Technology",
    "Trip",
    "Nature",
    "Culture",
    "Music",
    "Food",
    "Health",
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "What are you interested in?",
            style: currentTextTheme(context).bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color.dark100,
                  fontSize: 18.0,
                ),
          ),
        ),
        spacer(height: 25.0),
        Wrap(
          spacing: 16.0,
          runSpacing: 25.0,
          children: items.map((item) {
            return Selector<RegisterViewModel, String>(
              builder: (context, interestValue, child) {
                return InkWell(
                  overlayColor:
                      MaterialStateProperty.all<Color?>(Colors.transparent),
                  onTap: interestValue == item
                      ? () {}
                      : () {
                          context
                              .read<RegisterViewModel>()
                              .changeInterestValue(item);
                          context.read<RegisterViewModel>().updateProfileInfo(
                            {
                              "interest_tag": item,
                              "native_language_code": context
                                  .read<RegisterViewModel>()
                                  .languageCode,
                            },
                            pageController,
                          );
                        },
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: interestValue == item ? 0.5 : 0.2,
                    child: Chip(
                      backgroundColor: color.background,
                      label: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 24.0,
                        ),
                        child: Text(
                          item,
                          style: currentTextTheme(context).bodyLarge?.copyWith(
                                fontWeight: interestValue == item
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: color.dark100,
                                fontSize: 14.0,
                                fontFamily: font.regular,
                              ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              selector: (context, state) => state.interestValue,
            );
          }).toList(),
        )
      ],
    );
  }
}
