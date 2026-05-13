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
  final bool isDesktopLayout;

  const ExerciseDetailsContent({
    super.key,
    required this.exercise,
    required this.bottomActions,
    this.showTypePill = true,
    this.afterTitle,
    this.isDesktopLayout = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isDesktopLayout) {
      return _DesktopExerciseDetailsContent(
        exercise: exercise,
        bottomActions: bottomActions,
        showTypePill: showTypePill,
        afterTitle: afterTitle,
      );
    }

    return _MobileExerciseDetailsContent(
      exercise: exercise,
      bottomActions: bottomActions,
      showTypePill: showTypePill,
      afterTitle: afterTitle,
    );
  }
}

class _DesktopExerciseDetailsContent extends StatelessWidget {
  final Exercise exercise;
  final Widget bottomActions;
  final bool showTypePill;
  final Widget? afterTitle;

  const _DesktopExerciseDetailsContent({
    required this.exercise,
    required this.bottomActions,
    required this.showTypePill,
    required this.afterTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 430,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ExerciseMediaSlider(
                mediaUrls: exercise.mediaUrls,
              ),

              const SizedBox(height: 18),

              Text(
                exercise.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 16),

              if (showTypePill) ...[
                _ExerciseTypePill(exercise: exercise),
                const SizedBox(height: 16),
              ],

              if (afterTitle != null) ...[
                afterTitle!,
                const SizedBox(height: 16),
              ],

              _ExerciseDescriptionCard(
                description: exercise.description,
              ),
            ],
          ),
        ),

        const SizedBox(width: 28),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Инструкция',
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 14),

              ...List.generate(exercise.steps.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ExerciseInstructionCard(
                    number: index + 1,
                    text: exercise.steps[index],
                  ),
                );
              }),

              const SizedBox(height: 8),

              bottomActions,
            ],
          ),
        ),
      ],
    );
  }
}

class _MobileExerciseDetailsContent extends StatelessWidget {
  final Exercise exercise;
  final Widget bottomActions;
  final bool showTypePill;
  final Widget? afterTitle;

  const _MobileExerciseDetailsContent({
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
          _ExerciseTypePill(exercise: exercise),
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

class _ExerciseTypePill extends StatelessWidget {
  final Exercise exercise;

  const _ExerciseTypePill({
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    
    return Container(
      width: double.infinity,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        exerciseTypeLabel(exercise.type),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}

class _ExerciseDescriptionCard extends StatelessWidget {
  final String description;

  const _ExerciseDescriptionCard({
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Описание',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}