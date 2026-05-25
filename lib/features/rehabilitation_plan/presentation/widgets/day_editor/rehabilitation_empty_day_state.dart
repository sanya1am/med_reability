import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';

class RehabilitationEmptyDayState extends StatelessWidget {
  final VoidCallback onAddExercise;

  const RehabilitationEmptyDayState({
    super.key,
    required this.onAddExercise,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.info_outline,
          size: 42,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'В этот день назначено 0\nупражнений.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: 250,
          child: PrimaryButton(
            text: 'Добавить упражнение',
            onPressed: onAddExercise,
            height: 38,
            textStyle: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ],
    );
  }
}