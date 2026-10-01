
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

const kAnimFadeDuration = Duration(milliseconds: 300);
const kAnimStaggerDelay = Duration(milliseconds: 50);
const kAnimSlideDuration = Duration(milliseconds: 300);
const double kAnimSlideBegin = -0.04;
const Curve kAnimCurve = Curves.easeOutCubic;

class AnimatedColumn extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final VerticalDirection verticalDirection;
  final TextDirection? textDirection;
  final TextBaseline? textBaseline;
  final double? spacing;

  const AnimatedColumn({
    super.key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.verticalDirection = VerticalDirection.down,
    this.textDirection,
    this.textBaseline,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    int animIndex = 0;
    final animatedChildren = children.map((child) {
      final isSpacer = child is SizedBox || child is Divider;
      final index = animIndex;
      if (!isSpacer) {
        animIndex++;
      }

      if (isSpacer) {
        return child;
      }

      return child
          .animate()
          .fadeIn(duration: kAnimFadeDuration, delay: kAnimStaggerDelay * index)
          .slideX(
            begin: kAnimSlideBegin,
            end: 0,
            duration: kAnimSlideDuration,
            delay: kAnimStaggerDelay * index,
            curve: kAnimCurve,
          );
    }).toList();

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      verticalDirection: verticalDirection,
      textDirection: textDirection,
      textBaseline: textBaseline,
      spacing: spacing ?? 0.0,
      children: animatedChildren,
    );
  }
}
