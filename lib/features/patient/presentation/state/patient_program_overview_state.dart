import 'package:med_reability/features/patient/domain/entities/patient_selected_day_progress.dart';

import '../../domain/entities/patient_program_day.dart';
import '../../domain/entities/patient_program_overview.dart';
import '../../domain/entities/patient_today_workout.dart';

class PatientProgramOverviewState {
  final PatientProgramOverview overview;
  final DateTime weekStartDate;
  final DateTime selectedDate;

  const PatientProgramOverviewState({
    required this.overview,
    required this.weekStartDate,
    required this.selectedDate,
  });

  PatientProgramOverviewState copyWith({
    PatientProgramOverview? overview,
    DateTime? weekStartDate,
    DateTime? selectedDate,
  }) {
    return PatientProgramOverviewState(
      overview: overview ?? this.overview,
      weekStartDate: weekStartDate ?? this.weekStartDate,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  bool get hasPlan => overview.hasPlan;

  int get progressPercent => overview.progress?.completionPercent ?? 0;

  List<PatientProgramDay> get days => overview.days;

  PatientTodayWorkout? get workout => overview.todayWorkout;

  bool get hasWorkoutExercises {
    final w = workout;
    return w != null && !w.isRestDay && w.exercises.isNotEmpty;
  }

  int get workoutExercisesCount {
    return workout?.exercises.length ?? 0;
  }

  bool get hasCompletedExercise {
    return workout?.exercises.any((x) => x.isCompleted) ?? false;
  }

  bool get isWorkoutCompletedToday {
    return workout?.isCompletedToday ?? false;
  }

  bool get isSelectedDateToday {
    final now = DateTime.now();

    return selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;
  }

  bool get canStartWorkout {
    return hasPlan && hasWorkoutExercises && isSelectedDateToday;
  }

  String get startButtonText {
    return hasCompletedExercise ? 'Продолжить' : 'Начать';
  }

  int? get currentDayNumber {
    return workout?.dayNumber;
  }

  String? get planId {
    return overview.plan?.id;
  }

  PatientSelectedDayProgress? get selectedDayProgress =>
      overview.selectedDayProgress;
}