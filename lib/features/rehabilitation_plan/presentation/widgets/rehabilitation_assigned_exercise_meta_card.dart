import 'package:flutter/material.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/state/rehabilitation_program_editor_state.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

class RehabilitationAssignedExerciseMetaCard extends StatelessWidget {
  final RehabilitationProgramExerciseDraft draft;

  const RehabilitationAssignedExerciseMetaCard({
    super.key,
    required this.draft,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final items = <_MetaItem>[
      _MetaItem('Подходы', draft.sets.toString()),
    ];

    if (draft.repetitions > 0) {
      items.add(_MetaItem('Повторения', draft.repetitions.toString()));
    }

    if (draft.durationSeconds > 0) {
      items.add(_MetaItem('Время', _formatDuration(draft.durationSeconds)));
    }

    if (draft.restBetweenSetsInSeconds > 0) {
      items.add(
        _MetaItem(
          'Отдых (мин)',
          _formatMinutes(draft.restBetweenSetsInSeconds),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.value,
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

    return '$minutes:$rest';
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