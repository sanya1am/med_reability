import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/page/rehabilitation_assigned_exercise_details_page.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/page/rehabilitation_day_exercise_delete_page.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/page/rehabilitation_exercise_picker_page.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/state/rehabilitation_program_editor_state.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/view_model/rehabilitation_program_editor_view_model.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/widgets/day_editor/rehabilitation_day_exercise_card.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/widgets/rehabilitation_plan_switcher.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/widgets/day_editor/rehabilitation_empty_day_state.dart';
import 'package:med_reability/utils/widgets/app_top_actions_bar.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';

import '../../../../utils/widgets/app_secondary_button.dart';

class RehabilitationProgramDayEditorPage extends ConsumerWidget {
  final RehabilitationProgramEditorArgs args;
  final int weekIndex;
  final int dayIndex;

  const RehabilitationProgramDayEditorPage({
    super.key,
    required this.args,
    required this.weekIndex,
    required this.dayIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      rehabilitationProgramEditorViewModelProvider(args),
    );

    final vm = ref.read(
      rehabilitationProgramEditorViewModelProvider(args).notifier,
    );

    if (weekIndex < 0 || weekIndex >= state.weeks.length) {
      return const _NotFoundState(text: 'Неделя не найдена');
    }

    final week = state.weeks[weekIndex];

    if (dayIndex < 0 || dayIndex >= week.days.length) {
      return const _NotFoundState(text: 'День не найден');
    }

    final day = week.days[dayIndex];

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 32),
          children: [
            AppTopActionsBar(
              onBack: () => Navigator.pop(context),
              onNotify: () {},
            ),

            const SizedBox(height: 28),

            RehabilitationPlanSwitcher(
              title: 'День ${day.dayNumber}',
              canGoPrevious: dayIndex > 0,
              canGoNext: dayIndex < week.days.length - 1,
              onPrevious: () => _replaceWithDay(context, dayIndex - 1),
              onNext: () => _replaceWithDay(context, dayIndex + 1),
            ),

            const SizedBox(height: 24),

            if (day.exercises.isEmpty)
              RehabilitationEmptyDayState(
                onAddExercise: () => _addExercise(context, vm),
              )
            else ...[
              ...List.generate(day.exercises.length, (exerciseIndex) {
                return RehabilitationDayExerciseCard(
                  item: day.exercises[exerciseIndex],
                  onEdit: () async {
                    final updated = await Navigator.of(context)
                        .push<RehabilitationProgramExerciseDraft>(
                      MaterialPageRoute(
                        builder: (_) => RehabilitationAssignedExerciseDetailsPage(
                          initialDraft: day.exercises[exerciseIndex],
                        ),
                      ),
                    );

                    if (updated == null) return;

                    vm.updateExerciseInDay(
                      weekIndex: weekIndex,
                      dayIndex: dayIndex,
                      exerciseIndex: exerciseIndex,
                      exercise: updated,
                    );
                  },
                );
              }),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: 'Удалить',
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => RehabilitationDayExerciseDeletePage(
                              args: args,
                              weekIndex: weekIndex,
                              dayIndex: dayIndex,
                            ),
                          ),
                        );
                      },
                      height: 38,
                      textStyle: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Добавить',
                      onPressed: () => _addExercise(context, vm),
                      height: 38,
                      textStyle: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _replaceWithDay(BuildContext context, int nextDayIndex) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => RehabilitationProgramDayEditorPage(
          args: args,
          weekIndex: weekIndex,
          dayIndex: nextDayIndex,
        ),
      ),
    );
  }

  Future<void> _addExercise(
      BuildContext context,
      RehabilitationProgramEditorViewModel vm,
      ) async {
    final draft = await Navigator.of(context)
        .push<RehabilitationProgramExerciseDraft>(
      MaterialPageRoute(
        builder: (_) => const RehabilitationExercisePickerPage(),
      ),
    );

    if (draft == null) return;

    vm.addExerciseToDay(
      weekIndex: weekIndex,
      dayIndex: dayIndex,
      exercise: draft,
    );
  }
}

class _NotFoundState extends StatelessWidget {
  final String text;

  const _NotFoundState({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(text),
        ),
      ),
    );
  }
}