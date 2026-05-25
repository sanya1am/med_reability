import 'package:flutter/material.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise_type.dart';
import 'package:med_reability/features/exercises/presentation/state/exercise_form_state.dart';
import 'package:med_reability/features/exercises/presentation/widgets/form/exercise_form_section_title.dart';
import 'package:med_reability/features/exercises/presentation/widgets/form/exercise_tracking_type_selector.dart';
import 'package:med_reability/utils/widgets/app_text_field.dart';

class ExerciseFormMainFieldsSection extends StatelessWidget {
  final ExerciseFormState formState;
  final TextEditingController nameCtrl;
  final TextEditingController descCtrl;
  final ValueChanged<ExerciseType?> onTypeChanged;

  const ExerciseFormMainFieldsSection({
    super.key,
    required this.formState,
    required this.nameCtrl,
    required this.descCtrl,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ExerciseFormSectionTitle(text: 'Режим'),
        const SizedBox(height: 8),
        ExerciseTrackingTypeSelector(
          value: formState.type,
          onChanged: onTypeChanged,
        ),

        const SizedBox(height: 14),

        const ExerciseFormSectionTitle(text: 'Название'),
        const SizedBox(height: 8),
        AppTextField(
          hintText: 'Введите название упражнения',
          controller: nameCtrl,
        ),

        const SizedBox(height: 14),

        const ExerciseFormSectionTitle(text: 'Описание'),
        const SizedBox(height: 8),
        AppTextField(
          hintText: 'Введите описание упражнения',
          controller: descCtrl,
          maxLines: 4,
        ),
      ],
    );
  }
}