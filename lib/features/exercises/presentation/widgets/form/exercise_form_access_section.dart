import 'package:flutter/material.dart';
import 'package:med_reability/features/exercises/presentation/state/exercise_form_state.dart';
import 'package:med_reability/features/exercises/presentation/widgets/form/exercise_private_access_switch.dart';

class ExerciseFormAccessSection extends StatelessWidget {
  final ExerciseFormState formState;
  final ValueChanged<bool> onPrivateAccessChanged;

  const ExerciseFormAccessSection({
    super.key,
    required this.formState,
    required this.onPrivateAccessChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (formState.isEdit) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        ExercisePrivateAccessSwitch(
          isPrivate: !formState.isGlobal,
          onChanged: onPrivateAccessChanged,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}