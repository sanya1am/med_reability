import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

class ExerciseFilterChipButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;
  final TextStyle? textStyle;
  final Color? unselectedBackgroundColor;

  const ExerciseFilterChipButton({
    super.key,
    required this.text,
    required this.selected,
    required this.onTap,
    this.textStyle,
    this.unselectedBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final primary = Theme.of(context).colorScheme.primary;

    final effectiveTextStyle = textStyle ??
        Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
        );

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: selected
              ? primary
              : unselectedBackgroundColor ?? colors.dialogBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: primary,
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: effectiveTextStyle?.copyWith(
            color: selected ? Colors.white : primary,
          ),
        ),
      ),
    );
  }
}