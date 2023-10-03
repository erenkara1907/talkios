import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:talkios/core/view/base/base_state.dart';
import 'package:talkios/product/conversation/viewmodel/conversation_room_view_model.dart';

class CircleProgress extends StatefulWidget {
  final ConversationRoomViewModel viewModel;
  final double? circleRadius;
  final double? textFontSize;
  final double? lineWidth;
  final String? score;
  const CircleProgress({
    Key? key,
    required this.viewModel,
    this.circleRadius,
    this.textFontSize,
    this.lineWidth,
    this.score,
  }) : super(key: key);

  @override
  _CircleProgressState createState() => _CircleProgressState();
}

class _CircleProgressState extends BaseState<CircleProgress>
    with SingleTickerProviderStateMixin {
  double? _percent = 0.0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation =
        Tween<double>(begin: 0, end: 0.75).animate(_animationController)
          ..addListener(() {
            setState(() {
              _percent = _animation.value;
            });
          });

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Selector<ConversationRoomViewModel, String>(
        builder: (context, newScore, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CircularPercentIndicator(
                radius: widget.circleRadius ?? 50.0,
                lineWidth: widget.lineWidth ?? 5.0,
                animation: true,
                percent: newScore.isEmpty
                    ? widget.score!.isNotEmpty && widget.score != null
                        ? double.parse(widget.score!) / 100
                        : 0.0
                    : double.parse(newScore) / 100,
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: widget.viewModel.getScoreColor(
                  int.parse(newScore.isNotEmpty
                      ? newScore
                      : widget.score!.isNotEmpty && widget.score != null
                          ? widget.score!
                          : "0"),
                ),
                backgroundColor: widget.viewModel
                    .getScoreColor(
                      int.parse(newScore.isNotEmpty
                          ? newScore
                          : widget.score!.isNotEmpty && widget.score != null
                              ? widget.score!
                              : "0"),
                    )
                    .withOpacity(0.3),
              ),
              Text(
                newScore.isNotEmpty
                    ? newScore
                    : widget.score!.isNotEmpty
                        ? widget.score!
                        : "0",
                style: currentTextTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color.dark80,
                  fontSize: widget.textFontSize ?? 36.0,
                  fontFamily: font.semiBold,
                ),
              ),
            ],
          );
        },
        selector: (context, state) => state.score,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
