import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reability/core/router/app_route_names.dart';
import 'package:med_reability/features/doctor/presentation/view_model/doctor_patient_overview_view_model.dart';
import 'package:med_reability/features/doctor/presentation/widgets/doctor_patient_overview_header.dart';
import 'package:med_reability/features/doctor/presentation/widgets/patient_overview_empty_state.dart';
import 'package:med_reability/features/doctor/presentation/widgets/patient_program_exercise_list.dart';
import 'package:med_reability/features/doctor/presentation/widgets/patient_week_card.dart';
import 'package:med_reability/features/doctor/presentation/widgets/patient_week_progress_card.dart';
import 'package:med_reability/features/rehabilitation_plan/domain/entities/rehabilitation_program_exercise.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/page/day_well_being_view_page.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/page/rehabilitation_program_edit_loader_page.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/page/rehabilitation_program_weeks_page.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_breadcrumbs.dart';
import 'package:med_reability/utils/widgets/app_secondary_button.dart';
import 'package:med_reability/utils/widgets/app_top_actions_bar.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';

class DoctorPatientOverviewPage extends ConsumerWidget {
  final String patientId;

  const DoctorPatientOverviewPage({
    super.key,
    required this.patientId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(
      doctorPatientOverviewViewModelProvider(patientId),
    );

    final colors = context.appColors;

    return Scaffold(
      body: SafeArea(
        child: async.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Text(
                'Ошибка: $error',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ),
          ),
          data: (state) {
            final overview = state.overview;

            return LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 900;
                final patientTitle = overview.patient.fullName;

                return RefreshIndicator(
                  onRefresh: () {
                    return ref
                        .read(
                      doctorPatientOverviewViewModelProvider(patientId)
                          .notifier,
                    )
                        .refresh();
                  },
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(
                      isDesktop ? 28 : 14,
                      isDesktop ? 20 : 12,
                      isDesktop ? 28 : 14,
                      24,
                    ),
                    children: [
                      if (isDesktop) ...[
                        AppBreadcrumbs(
                          onBack: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.goNamed(AppRouteNames.doctorPatients);
                            }
                          },
                          items: [
                            AppBreadcrumbItem(
                              label: 'Пациенты',
                              onTap: () {
                                context.goNamed(AppRouteNames.doctorPatients);
                              },
                            ),
                            AppBreadcrumbItem(
                              label: patientTitle,
                            ),
                          ],
                        ),

                        const SizedBox(height: 26),

                        _DesktopPatientOverviewTopSection(
                          patientHeader: DoctorPatientOverviewHeader(
                            patient: overview.patient,
                          ),
                          weekCard: PatientWeekCard(
                            weekNumber: state.weekNumber,
                            days: state.days,
                            selectedDate: state.selectedDate,
                            canGoPreviousWeek: state.canGoPreviousWeek,
                            canGoNextWeek: state.canGoNextWeek,
                            onPreviousWeek: () {
                              ref
                                  .read(
                                doctorPatientOverviewViewModelProvider(
                                  patientId,
                                ).notifier,
                              )
                                  .previousWeek();
                            },
                            onNextWeek: () {
                              ref
                                  .read(
                                doctorPatientOverviewViewModelProvider(
                                  patientId,
                                ).notifier,
                              )
                                  .nextWeek();
                            },
                            onDayTap: (day) {
                              ref
                                  .read(
                                doctorPatientOverviewViewModelProvider(
                                  patientId,
                                ).notifier,
                              )
                                  .selectDay(day);
                            },
                          ),
                          progressCard: PatientWeekProgressCard(
                            percent: state.progressPercent,
                          ),
                          wellBeingButton: SecondaryButton(
                            text: 'Оценка самочувствия',
                            onPressed: () {
                              final progress = state.overview.selectedDayProgress;

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => DayWellBeingViewPage(
                                    wellBeingRating: progress?.wellBeingRating,
                                    workoutDifficultyRating: progress?.workoutDifficultyRating,
                                    hadPain: progress?.hadPain,
                                    painIntensityRating: progress?.painIntensityRating,
                                    breadcrumbLabels: [
                                      overview.patient.fullName,
                                      'Оценка самочувствия',
                                    ],
                                  ),
                                ),
                              );
                            },
                            height: 38,
                            textStyle: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),

                        const SizedBox(height: 24),
                      ] else ...[
                        AppTopActionsBar(
                          onBack: () => Navigator.pop(context),
                        ),

                        const SizedBox(height: 26),

                        DoctorPatientOverviewHeader(
                          patient: overview.patient,
                        ),

                        const SizedBox(height: 28),

                        PatientWeekCard(
                          weekNumber: state.weekNumber,
                          days: state.days,
                          selectedDate: state.selectedDate,
                          canGoPreviousWeek: state.canGoPreviousWeek,
                          canGoNextWeek: state.canGoNextWeek,
                          onPreviousWeek: () {
                            ref
                                .read(
                              doctorPatientOverviewViewModelProvider(
                                patientId,
                              ).notifier,
                            )
                                .previousWeek();
                          },
                          onNextWeek: () {
                            ref
                                .read(
                              doctorPatientOverviewViewModelProvider(
                                patientId,
                              ).notifier,
                            )
                                .nextWeek();
                          },
                          onDayTap: (day) {
                            ref
                                .read(
                              doctorPatientOverviewViewModelProvider(
                                patientId,
                              ).notifier,
                            )
                                .selectDay(day);
                          },
                        ),

                        const SizedBox(height: 16),

                        PatientWeekProgressCard(
                          percent: state.progressPercent,
                        ),

                        if (state.hasPlan) ...[
                          const SizedBox(height: 16),
                          SecondaryButton(
                            text: 'Оценка самочувствия',
                            onPressed: () {
                              final progress =
                                  state.overview.selectedDayProgress;

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => DayWellBeingViewPage(
                                    wellBeingRating: progress?.wellBeingRating,
                                    workoutDifficultyRating:
                                    progress?.workoutDifficultyRating,
                                    hadPain: progress?.hadPain,
                                    painIntensityRating:
                                    progress?.painIntensityRating,
                                  ),
                                ),
                              );
                            },
                            height: 38,
                            textStyle: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],

                        const SizedBox(height: 24),
                      ],

                      _DateRow(
                        date: state.selectedDate,
                        exercisesCount: state.selectedDayHasExercises
                            ? state.selectedProgramExercisesCount
                            : null,
                      ),

                      const SizedBox(height: 24),

                      _PatientOverviewContent(
                        isDesktop: isDesktop,
                        hasPlan: state.hasPlan,
                        selectedDayHasExercises: state.selectedDayHasExercises,
                        selectedProgramExercises: state.selectedProgramExercises,
                        onCreatePlan: () async {
                          final changed =
                          await Navigator.of(context).push<bool>(
                            MaterialPageRoute(
                              builder: (_) => RehabilitationProgramWeeksPage(
                                patientId: patientId,
                              ),
                            ),
                          );

                          if (changed == true && context.mounted) {
                            ref
                                .read(
                              doctorPatientOverviewViewModelProvider(
                                patientId,
                              ).notifier,
                            )
                                .refresh();
                          }
                        },
                        onEditPlan: () async {
                          final plan = overview.plan;
                          if (plan == null) return;

                          final changed =
                          await Navigator.of(context).push<bool>(
                            MaterialPageRoute(
                              builder: (_) =>
                                  RehabilitationProgramEditLoaderPage(
                                    programId: plan.id,
                                  ),
                            ),
                          );

                          if (changed == true && context.mounted) {
                            ref
                                .read(
                              doctorPatientOverviewViewModelProvider(
                                patientId,
                              ).notifier,
                            )
                                .refresh();
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _DesktopPatientOverviewTopSection extends StatelessWidget {
  final Widget patientHeader;
  final Widget weekCard;
  final Widget progressCard;
  final Widget? wellBeingButton;

  const _DesktopPatientOverviewTopSection({
    required this.patientHeader,
    required this.weekCard,
    required this.progressCard,
    this.wellBeingButton,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _DesktopPatientHeaderCard(
            child: patientHeader,
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              weekCard,

              const SizedBox(height: 16),

              progressCard,

              if (wellBeingButton != null) ...[
                const SizedBox(height: 16),
                wellBeingButton!,
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _DesktopPatientHeaderCard extends StatelessWidget {
  final Widget child;

  const _DesktopPatientHeaderCard({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      height: 288,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(32, 28, 32, 28),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}

class _PatientOverviewContent extends StatelessWidget {
  final bool isDesktop;
  final bool hasPlan;
  final bool selectedDayHasExercises;
  final List<RehabilitationProgramExercise> selectedProgramExercises;
  final VoidCallback onCreatePlan;
  final VoidCallback onEditPlan;

  const _PatientOverviewContent({
    required this.isDesktop,
    required this.hasPlan,
    required this.selectedDayHasExercises,
    required this.selectedProgramExercises,
    required this.onCreatePlan,
    required this.onEditPlan,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasPlan) {
      return Padding(
        padding: EdgeInsets.only(
          top: isDesktop ? 96 : 0,
        ),
        child: Center(
          child: SizedBox(
            width: isDesktop ? 270 : double.infinity,
            child: PatientOverviewEmptyState(
              text: 'У пациента ещё нет плана по\nреабилитации.',
              buttonText: 'Создать',
              onButtonPressed: onCreatePlan,
            ),
          ),
        ),
      );
    }

    if (!selectedDayHasExercises) {
      return Padding(
        padding: EdgeInsets.only(
          top: isDesktop ? 96 : 0,
        ),
        child: Center(
          child: SizedBox(
            width: isDesktop ? 270 : double.infinity,
            child: PatientOverviewEmptyState(
              text: 'На выбранный день тренировки нет.',
              buttonText: 'Редактировать',
              onButtonPressed: onEditPlan,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PatientProgramExerciseList(
          exercises: selectedProgramExercises,
        ),

        const SizedBox(height: 20),

        PrimaryButton(
          text: 'Редактировать',
          onPressed: onEditPlan,
          height: 38,
          textStyle: Theme.of(context).textTheme.titleSmall,
        ),
      ],
    );
  }
}

class _DateRow extends StatelessWidget {
  final DateTime date;
  final int? exercisesCount;

  const _DateRow({
    required this.date,
    required this.exercisesCount,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dateText = _formatDate(date);

    return Row(
      children: [
        Expanded(
          child: Text(
            dateText,
            style: textTheme.titleSmall,
          ),
        ),
        if (exercisesCount != null)
          Text(
            _formatExercisesCount(exercisesCount!),
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'января',
      'февраля',
      'марта',
      'апреля',
      'мая',
      'июня',
      'июля',
      'августа',
      'сентября',
      'октября',
      'ноября',
      'декабря',
    ];

    const weekdays = [
      'понедельник',
      'вторник',
      'среда',
      'четверг',
      'пятница',
      'суббота',
      'воскресенье',
    ];

    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];

    return '${_capitalize(weekday)}, ${date.day} $month';
  }

  String _formatExercisesCount(int count) {
    final mod10 = count % 10;
    final mod100 = count % 100;

    if (mod10 == 1 && mod100 != 11) {
      return '$count упражнение';
    }

    if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) {
      return '$count упражнения';
    }

    return '$count упражнений';
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;

    return value[0].toUpperCase() + value.substring(1);
  }
}