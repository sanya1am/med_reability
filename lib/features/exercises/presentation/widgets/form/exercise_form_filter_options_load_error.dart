import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

class ExerciseFormFilterOptionsLoadError extends StatelessWidget {
  const ExerciseFormFilterOptionsLoadError({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colors.border,
        ),
      ),
      child: Text(
        'Не удалось загрузить дополнительные фильтры упражнения. '
            'Можно сохранить упражнение без них.',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: colors.textSecondary,
        ),
      ),
    );
  }
}