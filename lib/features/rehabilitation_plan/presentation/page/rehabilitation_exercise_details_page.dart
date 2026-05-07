import 'package:flutter/material.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise.dart';
import 'package:med_reability/features/exercises/presentation/widgets/exercise_details_content.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/state/rehabilitation_program_editor_state.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/widgets/rehabilitation_exercise_settings_dialog.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_top_actions_bar.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';

class RehabilitationExerciseDetailsPage extends StatelessWidget {
  final Exercise exercise;

  const RehabilitationExerciseDetailsPage({
    super.key,
    required this.exercise,
  });

  Future<void> _openSettings(BuildContext context) async {
    final draft = await showRehabilitationExerciseSettingsDialog(
      context: context,
      exercise: exercise,
    );

    if (draft == null) return;
    if (!context.mounted) return;

    Navigator.of(context).pop(draft);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            AppTopActionsBar(onBack: () => Navigator.pop(context), onNotify: () {}),

            const SizedBox(height: 18),

            ExerciseDetailsContent(
              exercise: exercise,
              bottomActions: PrimaryButton(
                text: 'Настроить под пациента',
                onPressed: () => _openSettings(context),
                height: 38,
                textStyle: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}