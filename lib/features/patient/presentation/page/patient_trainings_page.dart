import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/features/patient/presentation/page/patient_workout_execution_page.dart';
import 'package:med_reability/features/patient/presentation/view_model/patient_program_overview_view_model.dart';
import 'package:med_reability/features/patient/presentation/widgets/patient_calendar_card.dart';
import 'package:med_reability/features/patient/presentation/widgets/patient_program_empty_state.dart';
import 'package:med_reability/features/patient/presentation/widgets/patient_training_exercise_list.dart';
import 'package:med_reability/features/patient/presentation/widgets/patient_training_progress_card.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/page/day_well_being_view_page.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_secondary_button.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';
import '../widgets/patient_training_date_row.dart';

class PatientTrainingsPage extends ConsumerWidget {
  const PatientTrainingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(patientProgramOverviewViewModelProvider);
    final colors = context.appColors;

    return async.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Text(
            'Ошибка: $e',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.textPrimary,
            ),
          ),
        ),
      ),
      data: (state) {
        return RefreshIndicator(
          onRefresh: () {
            return ref
                .read(patientProgramOverviewViewModelProvider.notifier)
                .refresh();
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(28, 16, 28, 120),
            children: [
              PatientCalendarCard(
                monthDate: state.weekStartDate,
                days: state.days,
                selectedDate: state.selectedDate,
                onPreviousWeek: () {
                  ref
                      .read(patientProgramOverviewViewModelProvider.notifier)
                      .previousWeek();
                },
                onNextWeek: () {
                  ref
                      .read(patientProgramOverviewViewModelProvider.notifier)
                      .nextWeek();
                },
                onDayTap: (date) {
                  ref
                      .read(patientProgramOverviewViewModelProvider.notifier)
                      .selectDay(date);
                },
              ),
              const SizedBox(height: 16),
              PatientTrainingProgressCard(
                percent: state.progressPercent,
              ),
              const SizedBox(height: 14),
              if (state.hasPlan)
                SecondaryButton(
                  text: 'Мое самочувствие',
                  onPressed: () {
                    final progress = state.overview.selectedDayProgress;

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DayWellBeingViewPage(
                          wellBeingRating: progress?.wellBeingRating,
                          workoutDifficultyRating: progress?.workoutDifficultyRating,
                          hadPain: progress?.hadPain,
                          painIntensityRating: progress?.painIntensityRating,
                        ),
                      ),
                    );
                  },
                  height: 38,
                  textStyle: Theme.of(context).textTheme.titleSmall
                ),

              const SizedBox(height: 22),
              PatientTrainingDateRow(
                date: state.selectedDate,
                exercisesCount:
                state.hasWorkoutExercises ? state.workoutExercisesCount : null,
              ),
              const SizedBox(height: 28),
              if (!state.hasPlan)
                const PatientProgramEmptyState(
                  title: 'План не назначен',
                  text: 'У вас пока нет назначенного плана реабилитации.',
                )
              else if (!state.hasWorkoutExercises)
                const PatientProgramEmptyState(
                  title: 'День отдыха',
                  text: 'На выбранный день тренировок не запланировано. Восстанавливайтесь!',
                  showSleepIcon: true,
                )
              else ...[
                  PatientTrainingExerciseList(
                    exercises: state.workout!.exercises,
                  ),
                  const SizedBox(height: 16),

                  if (state.canStartWorkout) ...[
                    const SizedBox(height: 16),
                    PrimaryButton(
                      text: state.startButtonText,
                      onPressed: () async {
                        final changed = await Navigator.of(context).push<bool>(
                          MaterialPageRoute(
                            builder: (_) => PatientWorkoutExecutionPage(
                              initialExercises: state.workout!.exercises,
                              planId: state.planId!,
                              dayNumber: state.currentDayNumber!,
                            ),
                          ),
                        );

                        if (changed == true && context.mounted) {
                          await ref
                              .read(patientProgramOverviewViewModelProvider.notifier)
                              .refresh();
                        }
                      },
                      height: 38,
                      textStyle: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ],
            ],
          ),
        );
      },
    );
  }
}