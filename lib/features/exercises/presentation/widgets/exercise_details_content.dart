import 'package:flutter/material.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise_type.dart';
import 'package:med_reability/features/exercises/presentation/widgets/exercise_instruction_card.dart';
import 'package:med_reability/features/exercises/presentation/widgets/exercise_media_slider.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

class ExerciseDetailsContent extends StatelessWidget {
  final Exercise exercise;
  final Widget bottomActions;
  final bool showTypePill;
  final Widget? afterTitle;

  const ExerciseDetailsContent({
    super.key,
    required this.exercise,
    required this.bottomActions,
    this.showTypePill = true,
    this.afterTitle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExerciseMediaSlider(
          mediaUrls: exercise.mediaUrls,
        ),

        const SizedBox(height: 10),

        if (showTypePill) ...[
          Container(
            width: double.infinity,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              exerciseTypeLabel(exercise.type),
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 18),
        ],

        Text(
          exercise.name,
          style: textTheme.headlineMedium,
        ),

        if (afterTitle != null) ...[
          const SizedBox(height: 14),
          afterTitle!,
        ],

        const SizedBox(height: 22),

        _ExerciseInfoCard(
          title: 'Описание',
          child: Text(
            exercise.description,
            style: textTheme.bodyMedium?.copyWith(
              color: colors.textPrimary,
            ),
          ),
        ),

        const SizedBox(height: 18),

        Text(
          'Инструкция',
          style: textTheme.titleMedium,
        ),

        const SizedBox(height: 12),

        ...List.generate(exercise.steps.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ExerciseInstructionCard(
              number: index + 1,
              text: exercise.steps[index],
            ),
          );
        }),

        const SizedBox(height: 10),

        bottomActions,
      ],
    );
  }
}

class _ExerciseInfoCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _ExerciseInfoCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}