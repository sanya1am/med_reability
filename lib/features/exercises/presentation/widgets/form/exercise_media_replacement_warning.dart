import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

class ExerciseMediaReplacementWarning extends StatelessWidget {
  const ExerciseMediaReplacementWarning({super.key});

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
        'Текущие медиафайлы будут заменены новыми при сохранении.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: colors.textPrimary,
        ),
      ),
    );
  }
}