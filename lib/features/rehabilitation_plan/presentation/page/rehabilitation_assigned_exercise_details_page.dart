import 'package:flutter/material.dart';
import 'package:med_reability/features/exercises/presentation/widgets/exercise_details_content.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/state/rehabilitation_program_editor_state.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/widgets/rehabilitation_assigned_exercise_meta_card.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/widgets/rehabilitation_exercise_settings_dialog.dart';
import 'package:med_reability/utils/widgets/app_secondary_button.dart';
import 'package:med_reability/utils/widgets/app_top_actions_bar.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';

class RehabilitationAssignedExerciseDetailsPage extends StatefulWidget {
  final RehabilitationProgramExerciseDraft initialDraft;

  const RehabilitationAssignedExerciseDetailsPage({
    super.key,
    required this.initialDraft,
  });

  @override
  State<RehabilitationAssignedExerciseDetailsPage> createState() =>
      _RehabilitationAssignedExerciseDetailsPageState();
}

class _RehabilitationAssignedExerciseDetailsPageState
    extends State<RehabilitationAssignedExerciseDetailsPage> {
  late RehabilitationProgramExerciseDraft draft;

  @override
  void initState() {
    super.initState();
    draft = widget.initialDraft;
  }

  Future<void> _edit() async {
    final exercise = draft.exercise;
    if (exercise == null) return;

    final updated = await showRehabilitationExerciseSettingsDialog(
      context: context,
      exercise: exercise,
      initialValue: draft,
    );

    if (updated == null) return;

    setState(() {
      draft = updated;
    });
  }

  @override
  Widget build(BuildContext context) {
    final exercise = draft.exercise;

    if (exercise == null) {
      return const Scaffold(
        body: SafeArea(
          child: Center(
            child: Text('Данные упражнения недоступны'),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            AppTopActionsBar(
              onBack: () => Navigator.pop(context),
              onNotify: () {},
            ),
            const SizedBox(height: 18),
            ExerciseDetailsContent(
              exercise: exercise,
              showTypePill: false,
              afterTitle: RehabilitationAssignedExerciseMetaCard(
                draft: draft,
              ),
              bottomActions: Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: 'Изменить',
                      onPressed: _edit,
                      height: 38,
                      textStyle: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Сохранить',
                      onPressed: () {
                        Navigator.of(context).pop(draft);
                      },
                      height: 38,
                      textStyle: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}