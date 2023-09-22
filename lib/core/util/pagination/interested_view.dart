import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/util/provider/time_provider.dart';
import 'package:talkios/core/view/base/base_stateless.dart';

import '../../../product/auth/register/register_view_model.dart';

class InterestedView extends BaseStateless {
  final PageController pageController;
  const InterestedView({
    super.key,
    required this.pageController,
  });

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
          spacing: 12.0,
          runSpacing: 25.0,
          children: context.read<RegisterViewModel>().interests.map((item) {
            return Selector<RegisterViewModel, List<int>>(
              builder: (context, selectedItems, child) {
                bool isSelected = selectedItems.contains(item.id);
                return InkWell(
                  overlayColor:
                      MaterialStateProperty.all<Color?>(Colors.transparent),
                  onTap: () {
                    if (isSelected) {
                      context.read<RegisterViewModel>().removeItem(item.id);
                    } else {
                      context.read<RegisterViewModel>().addItem(item.id);
                    }
                  },
                  child: Chip(
                    side: BorderSide(
                      width: 1.0,
                      color: isSelected ? color.background : Colors.transparent,
                    ),
                    backgroundColor: color.background.withOpacity(0.2),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        item.text,
                        style: currentTextTheme(context).bodyLarge?.copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: color.dark100,
                              fontSize: 14.0,
                              fontFamily: font.regular,
                            ),
                      ),
                    ),
                  ),
                );
              },
              selector: (context, state) => state.selectedInterestItems,
            );
          }).toList(),
        ),
        const Expanded(child: SizedBox()),
        Center(
          child: Text(
            "Select at least one interest to start!",
            style: currentTextTheme(context).bodyLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: color.background.withOpacity(0.7),
                  fontSize: 14.0,
                  fontFamily: font.regular,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        spacer(height: 10.0),
        Consumer<RegisterViewModel>(
          builder: (context, state, child) {
            return Center(
              child: InkWell(
                onTap: state.buttonFillPercentage
                    ? () async {
                        context.read<RegisterViewModel>().tapButton();
                        await context
                            .read<RegisterViewModel>()
                            .updateProfileInfo(
                          {
                            "interest_ids": context
                                .read<RegisterViewModel>()
                                .selectedInterestItems,
                            "native_language_code":
                                context.read<RegisterViewModel>().languageCode,
                            "learn_language_proficiency_cefr":
                                context.read<RegisterViewModel>().levelCode,
                            "target_id":
                                context.read<RegisterViewModel>().targetId,
                            "session_length":
                                context.read<RegisterViewModel>().selectedTime,
                            "time_of_reminder":
                                context.read<TimeProvider>().label,
                          },
                          pageController,
                        );
                        context.read<RegisterViewModel>().tapButton();
                      }
                    : null,
                child: AnimatedPadding(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(
                      horizontal: state.isTap ? 50.0 : 10.0),
                  child: AnimatedContainer(
                      width: width(context: context, value: 0.7),
                      height: height(context: context, value: 0.06),
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: state.buttonFillPercentage
                            ? color.dark100
                            : color.background.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(66.0),
                      ),
                      child: Center(
                        child: !state.isTap
                            ? Text(
                                "Complete",
                                style: currentTextTheme(context)
                                    .bodyLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: color.background,
                                      fontSize: 16.0,
                                      fontFamily: font.regular,
                                    ),
                              )
                            : CircularProgressIndicator(
                                strokeWidth: 2,
                                color: color.background,
                              ),
                      )),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
