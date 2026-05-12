import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

class ExerciseAssignmentMetaCard extends StatelessWidget {
  final int sets;
  final int repetitions;
  final int durationSeconds;
  final int restBetweenSetsInSeconds;

  const ExerciseAssignmentMetaCard({
    super.key,
    required this.sets,
    required this.repetitions,
    required this.durationSeconds,
    required this.restBetweenSetsInSeconds,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final items = <_MetaItem>[
      _MetaItem('Подходы', sets.toString()),
    ];

    if (repetitions > 0) {
      items.add(_MetaItem('Повторения', repetitions.toString()));
    }

    if (durationSeconds > 0) {
      items.add(_MetaItem('Время', _formatDuration(durationSeconds)));
    }

    if (restBetweenSetsInSeconds > 0) {
      items.add(
        _MetaItem(
          'Отдых (мин)',
          _formatMinutes(restBetweenSetsInSeconds),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: items.map((item) {
          return Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  item.label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.value,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) return '$seconds сек';

    final minutes = seconds ~/ 60;
    final rest = seconds % 60;

    if (rest == 0) return '$minutes мин';

    return '$minutes мин $rest сек';
  }

  String _formatMinutes(int seconds) {
    final value = seconds / 60;

    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(1).replaceAll('.', ',');
  }
}

class _MetaItem {
  final String label;
  final String value;

  const _MetaItem(this.label, this.value);
}