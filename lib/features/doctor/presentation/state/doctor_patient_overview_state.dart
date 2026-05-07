import '../../../rehabilitation_plan/domain/entities/rehabilitation_program.dart';
import '../../../rehabilitation_plan/domain/entities/rehabilitation_program_day.dart';
import '../../../rehabilitation_plan/domain/entities/rehabilitation_program_exercise.dart';
import '../../domain/entities/doctor_patient_overview.dart';
import '../../domain/entities/doctor_patient_overview_day.dart';

class DoctorPatientOverviewState {
  final String patientId;
  final DoctorPatientOverview overview;
  final RehabilitationProgram? program;
  final DateTime weekStartDate;
  final DateTime selectedDate;

  const DoctorPatientOverviewState({
    required this.patientId,
    required this.overview,
    required this.program,
    required this.weekStartDate,
    required this.selectedDate,
  });

  DoctorPatientOverviewState copyWith({
    String? patientId,
    DoctorPatientOverview? overview,
    RehabilitationProgram? program,
    DateTime? weekStartDate,
    DateTime? selectedDate,
  }) {
    return DoctorPatientOverviewState(
      patientId: patientId ?? this.patientId,
      overview: overview ?? this.overview,
      program: program ?? this.program,
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

  int get totalWeeksCount {
    final fullProgram = program;

    if (fullProgram != null && fullProgram.days.isNotEmpty) {
      final maxDayNumber = fullProgram.days
          .map((day) => day.dayNumber)
          .reduce((a, b) => a > b ? a : b);

      if (maxDayNumber <= 0) return 1;

      return (maxDayNumber / 7).ceil();
    }

    if (overview.days.isNotEmpty) {
      final maxDayNumber = overview.days
          .map((day) => day.dayNumber)
          .reduce((a, b) => a > b ? a : b);

      if (maxDayNumber <= 0) return 1;

      return (maxDayNumber / 7).ceil();
    }

    return 1;
  }

  bool get canGoPreviousWeek {
    return weekNumber > 1;
  }

  bool get canGoNextWeek {
    return weekNumber < totalWeeksCount;
  }

  RehabilitationProgramDay? get selectedProgramDay {
    final selectedOverviewDay = selectedDay;
    final fullProgram = program;

    if (selectedOverviewDay == null || fullProgram == null) return null;

    for (final day in fullProgram.days) {
      if (day.dayNumber == selectedOverviewDay.dayNumber) {
        return day;
      }
    }

    return null;
  }

  List<RehabilitationProgramExercise> get selectedProgramExercises {
    return selectedProgramDay?.exercises ?? const [];
  }

  bool get selectedDayHasExercises {
    return selectedProgramExercises.isNotEmpty;
  }

  int get selectedProgramExercisesCount {
    return selectedProgramExercises.length;
  }

  static bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}