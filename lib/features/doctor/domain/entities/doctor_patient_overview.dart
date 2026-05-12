import 'doctor_patient_overview_day.dart';
import 'doctor_patient_overview_patient.dart';
import 'doctor_patient_overview_plan.dart';
import 'doctor_patient_overview_progress.dart';
import 'doctor_patient_overview_workout.dart';
import 'doctor_patient_selected_day_progress.dart';

class DoctorPatientOverview {
  final DoctorPatientOverviewPatient patient;
  final bool hasPlan;
  final DoctorPatientOverviewPlan? plan;
  final DoctorPatientOverviewProgress? progress;
  final List<DoctorPatientOverviewDay> days;
  final DoctorPatientOverviewWorkout? todayWorkout;
  final DoctorPatientSelectedDayProgress? selectedDayProgress;

  const DoctorPatientOverview({
    required this.patient,
    required this.hasPlan,
    required this.plan,
    required this.progress,
    required this.days,
    required this.todayWorkout,
    required this.selectedDayProgress,
  });

  bool get hasTodayWorkout {
    final workout = todayWorkout;
    if (workout == null) return false;
    if (workout.isRestDay) return false;
    return workout.exercises.isNotEmpty;
  }
}