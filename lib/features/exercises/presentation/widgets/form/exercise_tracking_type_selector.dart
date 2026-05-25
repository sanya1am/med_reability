import 'package:flutter/material.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise_type.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

class ExerciseTrackingTypeSelector extends StatelessWidget {
  final ExerciseType value;
  final ValueChanged<ExerciseType?> onChanged;

  const ExerciseTrackingTypeSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final brightness = Theme.of(context).brightness;

    final selectedBackground = brightness == Brightness.dark
        ? colors.surface
        : colors.background;

    return Container(
      width: double.infinity,
      height: 38,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colors.dialogBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TrackingTypeSegment(
              text: 'Время',
              selected: value == ExerciseType.time,
              selectedBackground: selectedBackground,
              onTap: () => onChanged(ExerciseType.time),
            ),
          ),
          Expanded(
            child: _TrackingTypeSegment(
              text: 'Повторения',
              selected: value == ExerciseType.repetition,
              selectedBackground: selectedBackground,
              onTap: () => onChanged(ExerciseType.repetition),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackingTypeSegment extends StatelessWidget {
  final String text;
  final bool selected;
  final Color selectedBackground;
  final VoidCallback onTap;

  const _TrackingTypeSegment({
    required this.text,
    required this.selected,
    required this.selectedBackground,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? selectedBackground : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colors.textPrimary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}