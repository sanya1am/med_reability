import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:med_reability/features/patient/domain/entities/patient_program_overview.dart';
import 'package:med_reability/utils/assets/app_assets.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

import '../../domain/entities/patient_workout_exercise.dart';

class PatientTrainingExerciseList extends StatelessWidget {
  final List<PatientWorkoutExercise> exercises;

  const PatientTrainingExerciseList({
    super.key,
    required this.exercises,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = [...exercises]..sort((a, b) => a.order.compareTo(b.order));

    return Column(
      children: sorted.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _PatientTrainingExerciseCard(
            item: item,
          ),
        );
      }).toList(),
    );
  }
}

class _PatientTrainingExerciseCard extends StatelessWidget {
  final PatientWorkoutExercise item;

  const _PatientTrainingExerciseCard({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _ExerciseTextBlock(item: item),
          ),
          if (item.isCompleted) ...[
            const SizedBox(width: 12),
            SvgPicture.asset(
              AppAssets.readyExerciseIcon,
              width: 20,
              height: 20,
            ),
          ],
        ],
      ),
    );
  }
}

class _ExerciseTextBlock extends StatelessWidget {
  final PatientWorkoutExercise item;

  const _ExerciseTextBlock({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final exercise = item.exercise;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          exercise.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: 17,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _metaText(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          exercise.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colors.textPrimary,
          ),
        ),
      ],
    );
  }

  String _metaText() {
    final parts = <String>[];

    if (item.sets > 0) parts.add('${item.sets} ${_setsLabel(item.sets)}');
    if (item.repetitions > 0) parts.add('${item.repetitions} повторений');
    if (item.durationSeconds > 0) parts.add(_formatDuration(item.durationSeconds));
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