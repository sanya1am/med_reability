import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

import '../../../../utils/widgets/app_text_field.dart';
import 'exercise_step_number.dart';

class ExerciseCreateStepInput extends StatelessWidget {
  final int index;
  final TextEditingController controller;
  final bool canRemove;
  final VoidCallback? onRemove;

  const ExerciseCreateStepInput({
    super.key,
    required this.index,
    required this.controller,
    required this.canRemove,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ExerciseStepNumberBadge(
            number: index + 1,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: AppTextField(
              hintText: index == 0 ? 'Введите описание шага' : 'Добавить шаг',
              controller: controller,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: canRemove ? onRemove : null,
            child: Icon(
              Icons.close,
              size: 18,
              color: canRemove
                  ? colors.textSecondary
                  : colors.textSecondary.withOpacity(0.45),
            ),
          ),
        ],
      ),
    );
  }
}