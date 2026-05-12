import 'patient_program_day.dart';
import 'patient_program_plan.dart';
import 'patient_program_progress.dart';
import 'patient_selected_day_progress.dart';
import 'patient_today_workout.dart';

class PatientProgramOverview {
  final bool hasPlan;
  final PatientProgramPlan? plan;
  final PatientProgramProgress? progress;
  final List<PatientProgramDay> days;
  final PatientTodayWorkout? todayWorkout;
  final PatientSelectedDayProgress? selectedDayProgress;

  const PatientProgramOverview({
    required this.hasPlan,
    required this.plan,
    required this.progress,
    required this.days,
    required this.todayWorkout,
    required this.selectedDayProgress,
  });
}

