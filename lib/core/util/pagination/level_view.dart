import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/product/auth/register/model/english_level_model.dart';
import 'package:talkios/product/auth/register/register_view_model.dart';

import '../../view/widget/button/register_process_button.dart';

class LevelView extends BaseStateless {
  final PageController pageController;
  const LevelView({
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
            "How is your English level?",
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
            itemCount: context.read<RegisterViewModel>().englishLevels.length,
            itemBuilder: (context, index) {
              List<EnglishLevelModel> level =
                  context.read<RegisterViewModel>().englishLevels;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Selector<RegisterViewModel, int>(
                    builder: (context, isSelected, child) {
                      return RegisterProcessButton(
                        text: level[index].text,
                        isLanguage: false,
                        isSelected: isSelected == index ? true : false,
                        onPressed: () {
                          Provider.of<RegisterViewModel>(context, listen: false)
                              .setIndexToLevelButton(index);
                          context
                              .read<RegisterViewModel>()
                              .changeLevelCode(level[index].code);
                          Future.delayed(
                            const Duration(milliseconds: 650),
                            () {
                              RegisterViewModel.goToNextPage(pageController);
                            },
                          );
                        },
                      );
                    },
                    selector: (context, state) => state.levelButtonIndex),
              );
            },
          ),
        ),
      ],
    );
  }
}
