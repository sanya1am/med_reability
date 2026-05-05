import 'package:flutter/material.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise_type.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

import '../../domain/entities/doctor_patient_overview_workout_exercise.dart';

class PatientTodayWorkoutCard extends StatelessWidget {
  final DoctorPatientOverviewWorkoutExercise item;

  const PatientTodayWorkoutCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final exercise = item.exercise;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exercise.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _buildMetaText(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            exercise.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _buildMetaText() {
    final parts = <String>[];

    if (item.sets > 0) {
      parts.add('${item.sets} ${_formatSets(item.sets)}');
    }

    if (item.exercise.type == ExerciseType.repetition && item.repetitions > 0) {
      parts.add('${item.repetitions} повторений');
    }

    if (item.exercise.type == ExerciseType.time && item.durationSeconds > 0) {
      parts.add(_formatDuration(item.durationSeconds));
    }

    if (item.restAfterInSeconds > 0) {
      parts.add('${_formatDuration(item.restAfterInSeconds)} отдых');
    }

    if (parts.isEmpty) {
      return exerciseTypeLabel(item.exercise.type);
    }

    return parts.join(' · ');
  }

  String _formatSets(int count) {
    final mod10 = count % 10;
    final mod100 = count % 100;

    if (mod10 == 1 && mod100 != 11) return 'подход';
    if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) {
      return 'подхода';
    }

    return 'подходов';
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) {
      return '$seconds сек';
    }

    final minutes = seconds ~/ 60;
    final restSeconds = seconds % 60;

    if (restSeconds == 0) {
      return '$minutes мин';
    }

    return '$minutes мин $restSeconds сек';
  }
}