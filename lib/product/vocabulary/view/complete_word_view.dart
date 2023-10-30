import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/core/view/widget/button/app_button.dart';

import '../../../core/util/provider/sound/speech_provider.dart';
import '../../home/view/new_home_view.dart';

class CompleteWordView extends BaseStateless {
  const CompleteWordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              image.background,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              spacer(height: 56.0),
              Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    iconSize: 32.0,
                    onPressed: () {
                      context.read<SpeechProvider>().lastWords = "";
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const HomeView()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    icon: SvgPicture.asset(
                      icon.close,
                      color: color.dark100,
                      width: 32.0,
                      height: 32.0,
                    ),
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
              Text(
                "Completed Vocabulary 🎉",
                style: currentTextTheme(context).bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: color.dark100,
                      fontFamily: font.semiBold,
                      fontSize: 24.0,
                    ),
              ),
              spacer(height: 5.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Text(
                  "You have completed this level. You continue on your way to learn new words.",
                  style: currentTextTheme(context).bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: color.dark50,
                        fontSize: 14.0,
                        fontFamily: font.medium,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              spacer(height: 15.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SvgPicture.asset(image.completeVocabulary),
              ),
              const Expanded(flex: 2, child: SizedBox()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                child: AppButton(
                  widthValue: width(context: context, value: 1.0),
                  heightValue: height(context: context, value: 0.07),
                  text: "Complete Words",
                  textStyle: currentTextTheme(context).bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: color.background,
                        fontSize: 14.0,
                        fontFamily: font.bold,
                      ),
                  borderRadius: 66.0,
                  backgroundColor: color.dark100,
                  onPressed: () {
                    context.read<SpeechProvider>().lastWords = "";
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const HomeView()),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ),
              spacer(height: 33.0),
            ],
          ),
        ],
      ),
    );
  }
}
