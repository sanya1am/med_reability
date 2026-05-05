import 'doctor_patient_overview_workout_exercise.dart';

class DoctorPatientOverviewWorkout {
  final DateTime date;
  final int dayNumber;
  final bool isCompletedToday;
  final bool isRestDay;
  final List<DoctorPatientOverviewWorkoutExercise> exercises;

  const DoctorPatientOverviewWorkout({
    required this.date,
    required this.dayNumber,
    required this.isCompletedToday,
    required this.isRestDay,
    required this.exercises,
  });

  bool get hasExercises => exercises.isNotEmpty;
}