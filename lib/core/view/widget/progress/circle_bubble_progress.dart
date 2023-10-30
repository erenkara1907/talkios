import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:talkios/core/view/base/base_state.dart';
import 'package:talkios/product/conversation/viewmodel/conversation_room_view_model.dart';

class CircleBubbleProgress extends StatefulWidget {
  final ConversationRoomViewModel viewModel;
  final double? circleRadius;
  final double? textFontSize;
  final double? lineWidth;
  final String? score;
  const CircleBubbleProgress({
    Key? key,
    required this.viewModel,
    this.circleRadius,
    this.textFontSize,
    this.lineWidth,
    this.score,
  }) : super(key: key);

  @override
  _CircleBubbleProgressState createState() => _CircleBubbleProgressState();
}

class _CircleBubbleProgressState extends BaseState<CircleBubbleProgress>
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularPercentIndicator(
            radius: widget.circleRadius ?? 50.0,
            lineWidth: widget.lineWidth ?? 5.0,
            animation: true,
            percent: double.parse(widget.score!) / 100,
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: widget.viewModel.getScoreColor(
              int.parse(widget.score!),
            ),
            backgroundColor: widget.viewModel
                .getScoreColor(
                  int.parse(widget.score!),
                )
                .withOpacity(0.3),
          ),
          Text(
            widget.score ?? "0",
            style: currentTextTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: color.dark80,
              fontSize: widget.textFontSize ?? 36.0,
              fontFamily: font.semiBold,
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
