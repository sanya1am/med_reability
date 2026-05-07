import 'package:flutter/material.dart';
import 'package:med_reability/features/exercises/presentation/widgets/exercise_card.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/state/rehabilitation_program_editor_state.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_secondary_button.dart';

class RehabilitationDayExerciseCard extends StatelessWidget {
  final RehabilitationProgramExerciseDraft item;
  final VoidCallback onEdit;

  const RehabilitationDayExerciseCard({
    super.key,
    required this.item,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final exercise = item.exercise;

    if (exercise != null) {
      return ExerciseCard(
        exercise: exercise,
        metaText: _metaText(item),
        actionText: 'Редактировать',
        onAction: onEdit,
      );
    }

    final colors = context.appColors;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.exerciseName.isEmpty ? 'Упражнение' : item.exerciseName,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            _metaText(item),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: SecondaryButton(
              text: 'Редактировать',
              onPressed: onEdit,
              height: 38,
              textStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _metaText(RehabilitationProgramExerciseDraft item) {
    final parts = <String>[];

    if (item.sets > 0) {
      parts.add('${item.sets} ${_setsLabel(item.sets)}');
    }

    if (item.repetitions > 0) {
      parts.add('${item.repetitions} повторений');
    }

    if (item.durationSeconds > 0) {
      parts.add(_formatDuration(item.durationSeconds));
    }

    if (item.restBetweenSetsInSeconds > 0) {
      parts.add('${_formatDuration(item.restBetweenSetsInSeconds)} отдых');
    }

    return parts.isEmpty ? 'Настройки не указаны' : parts.join(' · ');
  }

  String _setsLabel(int count) {
    final mod10 = count % 10;
    final mod100 = count % 100;

    if (mod10 == 1 && mod100 != 11) return 'подход';
    if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) {
      return 'подхода';
    }

    return 'подходов';
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) return '$seconds сек';

    final minutes = seconds ~/ 60;
    final rest = seconds % 60;

    if (rest == 0) return '$minutes мин';

    return '$minutes мин $rest сек';
  }
}