import 'package:flutter/material.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise.dart';
import 'package:med_reability/features/exercises/presentation/widgets/exercise_details_content.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/state/rehabilitation_program_editor_state.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/widgets/rehabilitation_exercise_settings_dialog.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_top_actions_bar.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';

import '../widgets/rehabilitation_plan_page_layout.dart';

class RehabilitationExerciseDetailsPage extends StatelessWidget {
  final Exercise exercise;
  final List<String> breadcrumbLabels;

  const RehabilitationExerciseDetailsPage({
    super.key,
    required this.exercise,
    this.breadcrumbLabels = const [],
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
    final isDesktop = isRehabilitationPlanDesktopLayout(context);

    final labels = breadcrumbLabels.isNotEmpty
        ? breadcrumbLabels
        : [
      'Редактирование плана',
      'Добавить упражнение',
      exercise.name,
    ];

    return RehabilitationPlanPageLayout(
      breadcrumbs: rehabilitationPlanBreadcrumbs(
        context,
        labels,
      ),
      desktopHeaderSpacing: 22,
      mobileHeaderSpacing: 18,
      children: [
        ExerciseDetailsContent(
          exercise: exercise,
          isDesktopLayout: isDesktop,
          bottomActions: PrimaryButton(
            text: 'Настроить под пациента',
            onPressed: () => _openSettings(context),
            height: 38,
            textStyle: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ],
    );
  }
}