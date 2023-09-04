import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/view/base/base_state.dart';
import 'package:talkios/product/auth/register/register_view_model.dart';

import '../../../product/home/view/home_view.dart';

class CompleteRegisterView extends StatefulWidget {
  const CompleteRegisterView({super.key});

  @override
  State<CompleteRegisterView> createState() => _CompleteRegisterViewState();
}

class _CompleteRegisterViewState extends BaseState<CompleteRegisterView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _valueAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    // Tween ile değer animasyonu oluşturuyoruz
    _valueAnimation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        context.read<RegisterViewModel>().completeValue = _valueAnimation.value;
        if (_valueAnimation.value == 1.0) {
          RegisterViewModel viewModel = context.read<RegisterViewModel>();
          viewModel.setIndexToLanguageButton(-1);
          viewModel.setIndexToLevelButton(-1);
          viewModel.setIndexToTargetButton(-1);
          viewModel.setIndexToTimeButton(-1);
          viewModel.setPage(0);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeView()),
            (Route<dynamic> route) => false,
          );
        }
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(child: SizedBox()),
        Selector<RegisterViewModel, double>(
          builder: (context, value, child) {
            return SizedBox(
              width: 223.0,
              height: 223.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 223.0,
                    height: 223.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 10.0,
                      value: value,
                      backgroundColor: color.background,
                      valueColor: AlwaysStoppedAnimation<Color>(color.yellow),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 88.0,
                      horizontal: 42.0,
                    ),
                    child: Text(
                      "Your English lesson is loading.",
                      style: currentTextTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: color.background,
                        fontSize: 16.0,
                        fontFamily: font.medium,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            );
          },
          selector: (context, state) => state.completeValue,
        ),
        const Expanded(child: SizedBox()),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "How do cats\nmeow in english?",
              style: currentTextTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w400,
                color: color.background,
                fontSize: 16.0,
                fontFamily: font.regular,
              ),
            ),
            Image.asset(image.yellowCat),
          ],
        ),
        spacer(height: 40.0),
      ],
    );
  }
}
