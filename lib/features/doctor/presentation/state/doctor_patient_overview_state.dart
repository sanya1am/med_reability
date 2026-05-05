import '../../domain/entities/doctor_patient_overview.dart';
import '../../domain/entities/doctor_patient_overview_day.dart';

class DoctorPatientOverviewState {
  final String patientId;
  final DoctorPatientOverview overview;

  /// Дата начала текущей отображаемой недели.
  ///
  /// Это значение отправляется в query-параметр `startDate`
  /// при переключении недель.
  final DateTime weekStartDate;

  /// Выбранный день внутри текущей недели.
  ///
  /// Сейчас endpoint возвращает `todayWorkout`, поэтому выбранная дата
  /// в первую очередь нужна для UI: подсветка дня, заголовок даты,
  /// будущая привязка к тренировке выбранного дня.
  final DateTime selectedDate;

  const DoctorPatientOverviewState({
    required this.patientId,
    required this.overview,
    required this.weekStartDate,
    required this.selectedDate,
  });

  DoctorPatientOverviewState copyWith({
    String? patientId,
    DoctorPatientOverview? overview,
    DateTime? weekStartDate,
    DateTime? selectedDate,
  }) {
    return DoctorPatientOverviewState(
      patientId: patientId ?? this.patientId,
      overview: overview ?? this.overview,
      weekStartDate: weekStartDate ?? this.weekStartDate,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  List<DoctorPatientOverviewDay> get days {
    return overview.days;
  }

  DoctorPatientOverviewDay? get selectedDay {
    for (final day in days) {
      if (_isSameDate(day.date, selectedDate)) {
        return day;
      }
    }

    return null;
  }

  bool get hasPlan {
    return overview.hasPlan;
  }

  bool get hasTodayWorkout {
    return overview.hasTodayWorkout;
  }

  bool get hasWorkoutExercises {
    final workout = overview.todayWorkout;
    if (workout == null) return false;
    if (workout.isRestDay) return false;

    return workout.exercises.isNotEmpty;
  }

  int get workoutExercisesCount {
    final workout = overview.todayWorkout;
    if (workout == null) return 0;

    return workout.exercises.length;
  }

  int get progressPercent {
    return overview.progress?.completionPercent ?? 0;
  }

  int get weekNumber {
    final plan = overview.plan;
    if (plan == null) return 1;

    final start = _dateOnly(plan.startDate);
    final current = _dateOnly(weekStartDate);
    final diff = current.difference(start).inDays;

    if (diff < 0) return 1;

    return diff ~/ 7 + 1;
  }

  static bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}