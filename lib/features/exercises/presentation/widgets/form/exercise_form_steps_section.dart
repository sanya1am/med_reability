import 'package:flutter/material.dart';
import 'package:med_reability/features/exercises/presentation/state/exercise_form_state.dart';
import 'package:med_reability/features/exercises/presentation/widgets/exercise_create_step_input.dart';
import 'package:med_reability/features/exercises/presentation/widgets/form/exercise_form_section_title.dart';
import 'package:med_reability/utils/widgets/app_secondary_button.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';

class ExerciseFormStepsSection extends StatelessWidget {
  final ExerciseFormState formState;
  final List<TextEditingController> steps;
  final VoidCallback onAddStep;
  final ValueChanged<int> onRemoveStep;
  final VoidCallback onSubmit;
  final String submitText;
  final bool desktop;

  const ExerciseFormStepsSection({
    super.key,
    required this.formState,
    required this.steps,
    required this.onAddStep,
    required this.onRemoveStep,
    required this.onSubmit,
    required this.submitText,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ExerciseFormSectionTitle(text: 'Инструкция'),
        const SizedBox(height: 10),

        ...List.generate(steps.length, (index) {
          return ExerciseCreateStepInput(
            index: index,
            controller: steps[index],
            canRemove: steps.length > 1,
            onRemove: () => onRemoveStep(index),
          );
        }),

        const SizedBox(height: 8),

        if (desktop)
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  text: 'Добавить шаг',
                  onPressed: formState.isSubmitting ? null : onAddStep,
                  height: 38,
                  textStyle: textTheme.titleSmall,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  text: submitText,
                  onPressed: formState.isSubmitting ? null : onSubmit,
                  loading: formState.isSubmitting,
                  height: 38,
                  textStyle: textTheme.titleSmall,
                ),
              ),
            ],
          )
        else ...[
          SecondaryButton(
            text: 'Добавить шаг',
            onPressed: formState.isSubmitting ? null : onAddStep,
            height: 38,
            textStyle: textTheme.titleSmall,
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            text: submitText,
            onPressed: formState.isSubmitting ? null : onSubmit,
            loading: formState.isSubmitting,
            height: 38,
            textStyle: textTheme.titleSmall,
          ),
        ],
      ],
    );
  }
}