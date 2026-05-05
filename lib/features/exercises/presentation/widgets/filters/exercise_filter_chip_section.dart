import 'package:flutter/material.dart';
import 'exercise_filter_chip_button.dart';


class ExerciseFilterChipSection extends StatelessWidget {
  final String title;
  final List<String> values;
  final List<String> selectedValues;
  final ValueChanged<String> onToggle;
  final String Function(String value)? labelBuilder;
  final TextStyle? textStyle;
  final TextStyle? chipTextStyle;
  final Color? chipUnselectedBackgroundColor;

  const ExerciseFilterChipSection({
    super.key,
    required this.title,
    required this.values,
    required this.selectedValues,
    required this.onToggle,
    this.labelBuilder,
    this.textStyle,
    this.chipTextStyle,
    this.chipUnselectedBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return _FilterBlock(
      title: title,
      textStyle: textStyle,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: values.map((value) {
          final selected = selectedValues.contains(value);

          return ExerciseFilterChipButton(
            text: labelBuilder?.call(value) ?? value,
            selected: selected,
            onTap: () => onToggle(value),
            textStyle: chipTextStyle,
            unselectedBackgroundColor: chipUnselectedBackgroundColor,
          );
        }).toList(),
      ),
    );
  }
}

class _FilterBlock extends StatelessWidget {
  final String title;
  final Widget child;
  final TextStyle? textStyle;

  const _FilterBlock({
    required this.title,
    required this.child,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = textStyle ?? Theme.of(context).textTheme.titleSmall;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: effectiveStyle,
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}