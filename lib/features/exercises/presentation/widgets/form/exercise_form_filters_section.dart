import 'package:flutter/material.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise_filter_options.dart';
import 'package:med_reability/features/exercises/presentation/state/exercise_form_state.dart';
import 'package:med_reability/features/exercises/presentation/widgets/filters/exercise_filter_chip_section.dart';

class ExerciseFormFiltersSection extends StatelessWidget {
  final ExerciseFilterOptions options;
  final ExerciseFormState formState;
  final ValueChanged<String> onToggleBodyPart;
  final ValueChanged<String> onToggleInventory;
  final ValueChanged<String> onToggleExerciseType;

  const ExerciseFormFiltersSection({
    super.key,
    required this.options,
    required this.formState,
    required this.onToggleBodyPart,
    required this.onToggleInventory,
    required this.onToggleExerciseType,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
      fontSize: 18,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (options.bodyParts.isNotEmpty) ...[
          ExerciseFilterChipSection(
            title: 'Часть тела',
            values: options.bodyParts,
            selectedValues: formState.bodyParts,
            onToggle: onToggleBodyPart,
            textStyle: titleStyle,
          ),
          const SizedBox(height: 16),
        ],
        if (options.inventory.isNotEmpty) ...[
          ExerciseFilterChipSection(
            title: 'Инвентарь',
            values: options.inventory,
            selectedValues: formState.inventory,
            onToggle: onToggleInventory,
            textStyle: titleStyle,
          ),
          const SizedBox(height: 16),
        ],
        if (options.exerciseTypes.isNotEmpty) ...[
          ExerciseFilterChipSection(
            title: 'Тип упражнения',
            values: options.exerciseTypes,
            selectedValues: formState.exerciseTypes,
            onToggle: onToggleExerciseType,
            textStyle: titleStyle,
          ),
        ],
      ],
    );
  }
}