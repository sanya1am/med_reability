import 'package:flutter/material.dart';
import 'package:med_reability/features/exercises/presentation/widgets/filters/exercise_filter_chip_button.dart';

class ExerciseFilterChipSection extends StatelessWidget {
  final String title;
  final List<String> values;
  final List<String> selectedValues;
  final ValueChanged<String> onToggle;
  final String Function(String value)? labelBuilder;

  const ExerciseFilterChipSection({
    super.key,
    required this.title,
    required this.values,
    required this.selectedValues,
    required this.onToggle,
    this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return _FilterBlock(
      title: title,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: values.map((value) {
          final selected = selectedValues.contains(value);

          return ExerciseFilterChipButton(
            text: labelBuilder?.call(value) ?? value,
            selected: selected,
            onTap: () => onToggle(value),
          );
        }).toList(),
      ),
    );
  }
}

class _FilterBlock extends StatelessWidget {
  final String title;
  final Widget child;

  const _FilterBlock({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}