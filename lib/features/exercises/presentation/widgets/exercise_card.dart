import 'package:flutter/material.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise_type.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_secondary_button.dart';

class ExerciseCard extends StatelessWidget {
  final Exercise exercise;
  final String actionText;
  final VoidCallback onAction;
  final String? metaText;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.actionText,
    required this.onAction,
    this.metaText,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final subtitle = metaText ??
        (exercise.type == ExerciseType.repetition ? 'На повторения' : 'На время');

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
            exercise.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            exercise.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: SecondaryButton(
              text: actionText,
              onPressed: onAction,
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
}