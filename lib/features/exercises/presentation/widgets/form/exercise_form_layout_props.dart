import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise_filter_options.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise_type.dart';
import 'package:med_reability/features/exercises/presentation/state/exercise_form_state.dart';

class ExerciseFormLayoutProps {
  final ExerciseFormState formState;
  final AsyncValue<ExerciseFilterOptions> filterOptionsAsync;

  final TextEditingController nameCtrl;
  final TextEditingController descCtrl;
  final List<TextEditingController> steps;

  final String submitText;

  final VoidCallback onBack;
  final VoidCallback onPickMedia;
  final ValueChanged<int> onRemovePickedMediaAt;

  final ValueChanged<ExerciseType?> onTypeChanged;
  final ValueChanged<bool> onPrivateAccessChanged;

  final ValueChanged<String> onToggleBodyPart;
  final ValueChanged<String> onToggleInventory;
  final ValueChanged<String> onToggleExerciseType;

  final VoidCallback onAddStep;
  final ValueChanged<int> onRemoveStep;

  final VoidCallback onSubmit;

  const ExerciseFormLayoutProps({
    required this.formState,
    required this.filterOptionsAsync,
    required this.nameCtrl,
    required this.descCtrl,
    required this.steps,
    required this.submitText,
    required this.onBack,
    required this.onPickMedia,
    required this.onRemovePickedMediaAt,
    required this.onTypeChanged,
    required this.onPrivateAccessChanged,
    required this.onToggleBodyPart,
    required this.onToggleInventory,
    required this.onToggleExerciseType,
    required this.onAddStep,
    required this.onRemoveStep,
    required this.onSubmit,
  });
}