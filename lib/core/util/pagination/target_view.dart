import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/product/auth/register/model/target_model.dart';
import 'package:talkios/product/auth/register/register_view_model.dart';

import '../../view/widget/button/register_process_button.dart';

class TargetView extends BaseStateless {
  final PageController pageController;
  const TargetView({
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
            "What's your target?",
            style: currentTextTheme(context).bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color.dark100,
                  fontSize: 18.0,
                ),
          ),
        ),
        spacer(height: 25.0),
        Expanded(
          child: ListView.builder(
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: false,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: context.read<RegisterViewModel>().targets.length,
            itemBuilder: (context, index) {
              List<TargetModel> target =
                  context.read<RegisterViewModel>().targets;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Selector<RegisterViewModel, int>(
                    builder: (context, isSelected, child) {
                      return RegisterProcessButton(
                        text: target[index].text,
                        isLanguage: false,
                        isSelected: isSelected == index ? true : false,
                        onPressed: () {
                          Provider.of<RegisterViewModel>(context, listen: false)
                              .setIndexToTargetButton(index);
                          Future.delayed(
                            const Duration(milliseconds: 650),
                            () {
                              RegisterViewModel.goToNextPage(pageController);
                            },
                          );
                        },
                      );
                    },
                    selector: (context, state) => state.targetButtonIndex),
              );
            },
          ),
        ),
      ],
    );
  }
}
