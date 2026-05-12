import 'package:flutter/material.dart';
import 'package:med_reability/features/exercises/presentation/widgets/exercise_assignment_meta_card.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/state/rehabilitation_program_editor_state.dart';

class RehabilitationAssignedExerciseMetaCard extends StatelessWidget {
  final RehabilitationProgramExerciseDraft draft;

  const RehabilitationAssignedExerciseMetaCard({
    super.key,
    required this.draft,
  });

  @override
  Widget build(BuildContext context) {
    return ExerciseAssignmentMetaCard(
      sets: draft.sets,
      repetitions: draft.repetitions,
      durationSeconds: draft.durationSeconds,
      restBetweenSetsInSeconds: draft.restBetweenSetsInSeconds,
    );
  }
}