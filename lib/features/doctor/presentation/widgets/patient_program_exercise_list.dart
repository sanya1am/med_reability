import 'package:flutter/material.dart';
import 'package:med_reability/features/rehabilitation_plan/domain/entities/rehabilitation_program_exercise.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

class PatientProgramExerciseList extends StatelessWidget {
  final List<RehabilitationProgramExercise> exercises;

  const PatientProgramExerciseList({
    super.key,
    required this.exercises,
  });

  @override
  Widget build(BuildContext context) {
    final sorted = [...exercises]..sort((a, b) => a.order.compareTo(b.order));

    return Column(
      children: sorted.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _PatientProgramExerciseCard(
            item: item,
          ),
        );
      }).toList(),
    );
  }
}

class _PatientProgramExerciseCard extends StatelessWidget {
  final RehabilitationProgramExercise item;

  const _PatientProgramExerciseCard({
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
            exercise?.name ?? 'Упражнение',
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
          if (exercise?.description.trim().isNotEmpty == true) ...[
            const SizedBox(height: 10),
            Text(
              exercise!.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _buildMetaText() {
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