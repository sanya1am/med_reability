import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/features/exercises/presentation/widgets/form/exercise_form_access_section.dart';
import 'package:med_reability/features/exercises/presentation/widgets/form/exercise_form_filter_options_load_error.dart';
import 'package:med_reability/features/exercises/presentation/widgets/form/exercise_form_filters_section.dart';
import 'package:med_reability/features/exercises/presentation/widgets/form/exercise_form_layout_props.dart';
import 'package:med_reability/features/exercises/presentation/widgets/form/exercise_form_main_fields_section.dart';
import 'package:med_reability/features/exercises/presentation/widgets/form/exercise_form_media_section.dart';
import 'package:med_reability/features/exercises/presentation/widgets/form/exercise_form_small_loader.dart';
import 'package:med_reability/features/exercises/presentation/widgets/form/exercise_form_steps_section.dart';
import 'package:med_reability/utils/widgets/app_top_actions_bar.dart';

class ExerciseFormMobileLayout extends StatelessWidget {
  final ExerciseFormLayoutProps props;

  const ExerciseFormMobileLayout({
    super.key,
    required this.props,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 12, 28, 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTopActionsBar(
                onBack: props.onBack,
              ),

              const SizedBox(height: 16),

              ExerciseFormMediaSection(
                formState: props.formState,
                onPickMedia: props.onPickMedia,
                onRemovePickedMediaAt: props.onRemovePickedMediaAt,
              ),

              const SizedBox(height: 18),

              ExerciseFormMainFieldsSection(
                formState: props.formState,
                nameCtrl: props.nameCtrl,
                descCtrl: props.descCtrl,
                onTypeChanged: props.onTypeChanged,
              ),

              const SizedBox(height: 14),

              ExerciseFormAccessSection(
                formState: props.formState,
                onPrivateAccessChanged: props.onPrivateAccessChanged,
              ),

              props.filterOptionsAsync.when(
                loading: () => const ExerciseFormSmallLoader(),
                error: (_, __) => const ExerciseFormFilterOptionsLoadError(),
                data: (options) {
                  return ExerciseFormFiltersSection(
                    options: options,
                    formState: props.formState,
                    onToggleBodyPart: props.onToggleBodyPart,
                    onToggleInventory: props.onToggleInventory,
                    onToggleExerciseType: props.onToggleExerciseType,
                  );
                },
              ),

              const SizedBox(height: 16),

              ExerciseFormStepsSection(
                formState: props.formState,
                steps: props.steps,
                onAddStep: props.onAddStep,
                onRemoveStep: props.onRemoveStep,
                onSubmit: props.onSubmit,
                submitText: props.submitText,
                desktop: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}