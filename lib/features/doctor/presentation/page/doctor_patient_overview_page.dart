import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/features/doctor/presentation/view_model/doctor_patient_overview_view_model.dart';
import 'package:med_reability/features/doctor/presentation/widgets/doctor_patient_overview_header.dart';
import 'package:med_reability/features/doctor/presentation/widgets/patient_overview_empty_state.dart';

import 'package:med_reability/features/doctor/presentation/widgets/patient_week_card.dart';
import 'package:med_reability/features/doctor/presentation/widgets/patient_week_progress_card.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/page/rehabilitation_program_weeks_page.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_secondary_button.dart';
import 'package:med_reability/utils/widgets/app_top_actions_bar.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';

import '../../../rehabilitation_plan/presentation/page/rehabilitation_program_edit_loader_page.dart';
import '../widgets/patient_program_exercise_list.dart';

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

            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () {
                    return ref
                        .read(
                      doctorPatientOverviewViewModelProvider(patientId)
                          .notifier,
                    )
                        .refresh();
                  },
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(28, 16, 28, 24),
                    children: [
                      AppTopActionsBar(
                        onBack: () => Navigator.pop(context),
                        onNotify: () {},
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
                          ref.read(doctorPatientOverviewViewModelProvider(patientId).notifier).previousWeek();
                        },
                        onNextWeek: () {
                          ref.read(doctorPatientOverviewViewModelProvider(patientId).notifier).nextWeek();
                        },
                        onDayTap: (day) {
                          ref.read(doctorPatientOverviewViewModelProvider(patientId).notifier).selectDay(day);
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
                              // TODO: открыть экран опросов по тренировкам
                            },
                            height: 38,
                            textStyle:
                            Theme.of(context).textTheme.titleSmall
                        ),
                      ],

                      const SizedBox(height: 24),

                      _DateRow(
                        date: state.selectedDate,
                        exercisesCount: state.selectedDayHasExercises
                            ? state.selectedProgramExercisesCount
                            : null,
                      ),

                      const SizedBox(height: 24),

                      if (!state.hasPlan)
                        PatientOverviewEmptyState(
                          text: 'У пациента ещё нет плана по\nреабилитации.',
                          buttonText: 'Создать',
                          onButtonPressed: () async {
                            final changed = await Navigator.of(context).push<bool>(
                              MaterialPageRoute(
                                builder: (_) => RehabilitationProgramWeeksPage(
                                  patientId: patientId,
                                ),
                              ),
                            );

                            if (changed == true && context.mounted) {
                              ref.read(doctorPatientOverviewViewModelProvider(patientId).notifier).refresh();
                            }
                          },
                        )
                      else if (!state.selectedDayHasExercises)
                        PatientOverviewEmptyState(
                          text: 'На выбранный день тренировки нет.',
                          buttonText: 'Редактировать',
                          onButtonPressed: () async {
                            final changed = await Navigator.of(context).push<bool>(
                              MaterialPageRoute(
                                builder: (_) => RehabilitationProgramEditLoaderPage(
                                  programId: overview.plan!.id,
                                ),
                              ),
                            );

                            if (changed == true && context.mounted) {
                              ref.read(doctorPatientOverviewViewModelProvider(patientId).notifier).refresh();
                            }
                          },
                        )
                      else ...[
                        PatientProgramExerciseList(
                          exercises: state.selectedProgramExercises,
                        ),
                        const SizedBox(height: 20),
                        PrimaryButton(
                          text: 'Редактировать',
                          onPressed: () {
                            // редактирование плана
                          },
                          height: 38,
                          textStyle: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
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
            style: textTheme.titleSmall
          ),
        ),
        if (exercisesCount != null)
          Text(
            _formatExercisesCount(exercisesCount!),
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            )
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