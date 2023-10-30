// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/view/base/base_stateless.dart';
import 'package:talkios/product/auth/register/model/time_model.dart';
import 'package:talkios/product/auth/register/register_view_model.dart';

import '../../view/widget/button/register_process_button.dart';
import '../provider/onesignal_service.dart';

class TimeView extends BaseStateless {
  final PageController pageController;
  const TimeView({
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
            "How much time can you devote to learning a language?",
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
            itemCount: context.read<RegisterViewModel>().times.length,
            itemBuilder: (context, index) {
              List<TimeModel> time = context.read<RegisterViewModel>().times;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Selector<RegisterViewModel, int>(
                    builder: (context, isSelected, child) {
                      return RegisterProcessButton(
                        text: time[index].text,
                        isLanguage: false,
                        isSelected: isSelected == index ? true : false,
                        onPressed: () async {
                          await OneSignalService.setUpOneSignal(
                              isUsageDuration: false);
                          Provider.of<RegisterViewModel>(context, listen: false)
                              .setIndexToTimeButton(index);
                          context
                              .read<RegisterViewModel>()
                              .changeTime(time[index].time);
                          Future.delayed(
                            const Duration(milliseconds: 650),
                            () {
                              RegisterViewModel.goToNextPage(pageController);
                            },
                          );
                        },
                      );
                    },
                    selector: (context, state) => state.timeButtonIndex),
              );
            },
          ),
        ),
      ],
    );
  }
}
