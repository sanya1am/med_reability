import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

class ExerciseStepNumberBadge extends StatelessWidget {
  final int number;
  final double size;
  final double fontSize;
  final Color backgroundColor;
  final Color textColor;

  const ExerciseStepNumberBadge({
    super.key,
    required this.number,
    this.size = 30,
    this.fontSize = 16,
    this.backgroundColor = appPrimaryBlue,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Text(
        '$number',
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}