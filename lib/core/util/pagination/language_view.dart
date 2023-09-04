import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/product/auth/register/model/language_model.dart';
import 'package:talkios/product/auth/register/register_view_model.dart';

import '../../view/widget/button/register_process_button.dart';

class LanguageView extends BaseStateless {
  final PageController pageController;
  const LanguageView({
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
            "What is your native language?",
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
            itemCount: context.read<RegisterViewModel>().languages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Selector<RegisterViewModel, int>(
                    builder: (context, isSelected, child) {
                      List<LanguageModel> language =
                          context.read<RegisterViewModel>().languages;
                      return RegisterProcessButton(
                        text: language[index].text,
                        flag: language[index].flag,
                        isLanguage: true,
                        isSelected: isSelected == index ? true : false,
                        onPressed: () {
                          Provider.of<RegisterViewModel>(context, listen: false)
                              .setIndexToLanguageButton(index);
                          context
                              .read<RegisterViewModel>()
                              .changeLanguageCode(language[index].code);
                          Future.delayed(
                            const Duration(milliseconds: 650),
                            () {
                              RegisterViewModel.goToNextPage(pageController);
                            },
                          );
                        },
                      );
                    },
                    selector: (context, state) => state.languageButtonIndex),
              );
            },
          ),
        ),
      ],
    );
  }
}
