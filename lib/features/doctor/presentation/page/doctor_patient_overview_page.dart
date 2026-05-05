import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/features/doctor/presentation/view_model/doctor_patient_overview_view_model.dart';
import 'package:med_reability/features/doctor/presentation/widgets/doctor_patient_overview_header.dart';
import 'package:med_reability/features/doctor/presentation/widgets/patient_overview_empty_state.dart';
import 'package:med_reability/features/doctor/presentation/widgets/patient_today_workout_list.dart';
import 'package:med_reability/features/doctor/presentation/widgets/patient_week_card.dart';
import 'package:med_reability/features/doctor/presentation/widgets/patient_week_progress_card.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_secondary_button.dart';
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
                      _BackButton(
                        onTap: () => Navigator.of(context).pop(),
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

                      const SizedBox(height: 14),

                      PatientWeekProgressCard(
                        percent: state.progressPercent,
                      ),

                      const SizedBox(height: 14),

                      SecondaryButton(
                        text: 'Опросы по тренировкам',
                        onPressed: () {
                          // TODO: открыть экран опросов по тренировкам
                        },
                        height: 36,
                        textStyle:
                        Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 20),

                      _DateRow(
                        date: state.selectedDate,
                        exercisesCount: state.hasWorkoutExercises
                            ? state.workoutExercisesCount
                            : null,
                      ),

                      const SizedBox(height: 22),

                      if (!state.hasPlan)
                        PatientOverviewEmptyState(
                          text: 'У пациента ещё нет плана по\nреабилитации.',
                          buttonText: 'Создать',
                          onButtonPressed: () {
                            // TODO: открыть создание плана реабилитации
                          },
                        )
                      else if (!state.hasWorkoutExercises)
                        PatientOverviewEmptyState(
                          text: 'На выбранный день тренировки нет.',
                          buttonText: 'Редактировать',
                          onButtonPressed: () {
                            // TODO: открыть редактирование плана
                          },
                        )
                      else ...[
                          PatientTodayWorkoutList(
                            exercises: overview.todayWorkout!.exercises,
                          ),
                          const SizedBox(height: 16),
                          PrimaryButton(
                            text: 'Редактировать',
                            onPressed: () {
                              // TODO: открыть редактирование плана
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

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: colors.iconButtonBackground,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.chevron_left,
            size: 32,
            color: colors.textPrimary,
          ),
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
            style: textTheme.titleSmall?.copyWith(
              fontSize: 14,
            ),
          ),
        ),
        if (exercisesCount != null)
          Text(
            _formatExercisesCount(exercisesCount!),
            style: textTheme.titleSmall?.copyWith(
              fontSize: 14,
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