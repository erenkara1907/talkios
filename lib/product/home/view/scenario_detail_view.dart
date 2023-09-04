// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/core/view/widget/button/app_button.dart';
import 'package:talkios/product/home/home_view_model.dart';
import 'package:talkios/product/vocabulary/vocabulary_view.dart';

class ScenarioDetailView extends BaseStateless {
  final String subTitle;
  final String scenarioDescription;
  final String tagId;
  final int scenarioId;
  final String userProfilePhoto;
  final String aiProfilePhoto;
  const ScenarioDetailView({
    super.key,
    required this.subTitle,
    required this.scenarioDescription,
    required this.tagId,
    required this.scenarioId,
    required this.userProfilePhoto,
    required this.aiProfilePhoto,
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            image.background,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              spacer(height: 56.0),
              Align(
                alignment: Alignment.topLeft,
                child: Material(
                  type: MaterialType.transparency,
                  child: IconButton(
                    iconSize: 36.0,
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      back(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 36.0,
                    ),
                    color: color.dark100,
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
              Hero(
                tag: tagId,
                child: Text(
                  subTitle,
                  style: currentTextTheme(context).bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: color.dark100,
                        fontSize: 24.0,
                        fontFamily: font.semiBold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              spacer(height: 5.0),
              Text(
                scenarioDescription,
                style: currentTextTheme(context).bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: color.dark50,
                      fontSize: 14.0,
                      fontFamily: font.medium,
                    ),
                textAlign: TextAlign.center,
              ),
              const Expanded(flex: 2, child: SizedBox()),
              vocabularyButton(context),
              const Expanded(flex: 3, child: SizedBox()),
              Selector<HomeViewModel, bool>(
                builder: (context, isTap, child) {
                  return AnimatedPadding(
                    duration: const Duration(milliseconds: 300),
                    padding:
                        EdgeInsets.symmetric(horizontal: isTap ? 50.0 : 10.0),
                    child: AppButton(
                      widthValue: width(context: context, value: 1.0),
                      heightValue: height(context: context, value: 0.06),
                      text: "Start the Conversation",
                      borderRadius: 66.0,
                      isLoading: isTap,
                      backgroundColor: color.dark100,
                      onPressed: () async {
                        context.read<HomeViewModel>().tapButton();
                        await context.read<HomeViewModel>().storeConversation(
                              context,
                              scenarioId.toString(),
                              aiProfilePhoto,
                              userProfilePhoto,
                            );
                        context.read<HomeViewModel>().tapButton();
                      },
                      textStyle: currentTextTheme(context).bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: color.background,
                            fontSize: 14.0,
                            fontFamily: font.bold,
                          ),
                    ),
                  );
                },
                selector: (context, state) => state.isTap,
              ),
              spacer(height: 11.0),
              Text(
                "You are talking to an artificial intelligence, not a human.",
                style: currentTextTheme(context).bodyLarge?.copyWith(
                      fontWeight: FontWeight.w300,
                      color: color.dark40,
                      fontSize: 10.0,
                      fontFamily: font.light,
                    ),
              ),
              spacer(height: 40.0),
            ],
          ),
        ),
      ],
    );
  }

  Padding vocabularyButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SizedBox(
        width: width(context: context, value: 1.0),
        height: height(context: context, value: 0.1),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: color.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(
                  color: Color.fromRGBO(243, 243, 245, 1),
                  width: 1.0,
                ),
              )),
          onPressed: () => push(context, const VocabularyView()),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: SvgPicture.asset(icon.card)),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(left: 14.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Vocabulary",
                        style: currentTextTheme(context).bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: color.dark80,
                              fontSize: 16.0,
                              fontFamily: font.medium,
                            ),
                      ),
                      spacer(height: 4.0),
                      Text(
                        "Prepare for conversations by learning some new words.",
                        style: currentTextTheme(context).bodyLarge?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: color.dark40,
                              fontSize: 12.0,
                              fontFamily: font.regular,
                            ),
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.clip,
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    icon.arrowForward,
                    color: color.dark100,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
