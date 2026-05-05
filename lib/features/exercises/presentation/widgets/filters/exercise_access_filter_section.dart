import 'package:flutter/material.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise_filters.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

class ExerciseAccessFilterSection extends StatelessWidget {
  final ExerciseAccessFilter value;
  final ValueChanged<ExerciseAccessFilter> onChanged;

  const ExerciseAccessFilterSection({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _FilterBlock(
      title: 'Доступ',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AccessOption(
            title: 'Общие',
            value: ExerciseAccessFilter.global,
            groupValue: value,
            onChanged: onChanged,
          ),
          const SizedBox(height: 5),
          _AccessOption(
            title: 'Все',
            value: ExerciseAccessFilter.all,
            groupValue: value,
            onChanged: onChanged,
          ),
          const SizedBox(height: 5),
          _AccessOption(
            title: 'Только мои',
            value: ExerciseAccessFilter.mine,
            groupValue: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _AccessOption extends StatelessWidget {
  final String title;
  final ExerciseAccessFilter value;
  final ExerciseAccessFilter groupValue;
  final ValueChanged<ExerciseAccessFilter> onChanged;

  const _AccessOption({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  bool get _selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final primary = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: () => onChanged(value),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _AccessRadioIndicator(
            selected: _selected,
            selectedColor: primary,
            borderColor: _selected ? primary : colors.border,
          ),
          const SizedBox(width: 6),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _AccessRadioIndicator extends StatelessWidget {
  final bool selected;
  final Color selectedColor;
  final Color borderColor;

  const _AccessRadioIndicator({
    required this.selected,
    required this.selectedColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      height: 16,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
        ),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            width: selected ? 8 : 0,
            height: selected ? 8 : 0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selectedColor,
            ),
          ),
        ),
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