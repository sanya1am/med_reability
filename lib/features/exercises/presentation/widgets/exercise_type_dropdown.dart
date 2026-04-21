import 'package:flutter/material.dart';
import '../../../../utils/widgets/app_dropdown_field.dart';
import '../../domain/entities/exercise_type.dart';

class ExerciseTypeDropdown extends StatelessWidget {
  final ExerciseType value;
  final ValueChanged<ExerciseType?> onChanged;

  const ExerciseTypeDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppDropdownField<ExerciseType>(
      value: value,
      hintText: 'Выберите тип упражнения',
      onChanged: onChanged,
      items: const [
        DropdownMenuItem(
          value: ExerciseType.repetition,
          child: Text('На повторения'),
        ),
        DropdownMenuItem(
          value: ExerciseType.time,
          child: Text('На время'),
        ),
      ],
    );
  }
}