import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/util/provider/time_provider.dart';
import 'package:talkios/core/view/base/base_stateless.dart';

import '../../../product/auth/register/register_view_model.dart';

class PracticeView extends BaseStateless {
  final PageController pageController;
  const PracticeView({
    super.key,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Selector<TimeProvider, double>(
          builder: (context, sliderValue, child) {
            return AnimatedPositioned(
              bottom: 170.0,
              left: sliderValue == 1.0
                  ? 0.0
                  : sliderValue == 2.0
                      ? 20.0
                      : sliderValue == 3.0
                          ? 40.0
                          : 60.0,
              duration: const Duration(milliseconds: 300),
              child: Image.asset(image.practice),
            );
          },
          selector: (context, state) => state.currentSliderValue,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "When will you practice?",
                style: currentTextTheme(context).bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: color.dark100,
                      fontSize: 18.0,
                    ),
              ),
            ),
            const Expanded(child: SizedBox()),
            Align(
              alignment: Alignment.center,
              child: Text(
                Provider.of<TimeProvider>(context).label,
                style: currentTextTheme(context).bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: color.background,
                      fontSize: 24.0,
                    ),
              ),
            ),
            const Expanded(child: SizedBox()),
            Consumer<TimeProvider>(
              builder: (context, state, child) {
                return Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 15.0),
                        trackHeight: 4.0,
                      ),
                      child: Slider(
                        value: state.currentSliderValue,
                        activeColor: color.dark40,
                        inactiveColor: color.dark40,
                        thumbColor: color.dark100,
                        onChanged: (value) {
                          state.currentSliderValue = value;
                        },
                        onChangeEnd: (_) {
                          Future.delayed(
                            const Duration(milliseconds: 650),
                            () {
                              RegisterViewModel.goToNextPage(pageController);
                            },
                          );
                        },
                        divisions: 24,
                        label: state.label,
                        min: 1,
                        max: 24,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "06:00",
                            style:
                                currentTextTheme(context).bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: color.dark50,
                                      fontSize: 14.0,
                                    ),
                          ),
                          Text(
                            "12:00",
                            style:
                                currentTextTheme(context).bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: color.dark50,
                                      fontSize: 14.0,
                                    ),
                          ),
                          Text(
                            "18:00",
                            style:
                                currentTextTheme(context).bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: color.dark50,
                                      fontSize: 14.0,
                                    ),
                          ),
                          Text(
                            "00:00",
                            style:
                                currentTextTheme(context).bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: color.dark50,
                                      fontSize: 14.0,
                                    ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
            spacer(height: 80.0),
          ],
        ),
      ],
    );
  }
}
