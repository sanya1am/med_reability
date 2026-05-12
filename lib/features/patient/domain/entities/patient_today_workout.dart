import 'package:med_reability/features/patient/domain/entities/patient_workout_exercise.dart';

class PatientTodayWorkout {
  final DateTime date;
  final int dayNumber;
  final bool isCompletedToday;
  final bool isRestDay;
  final List<PatientWorkoutExercise> exercises;

  const PatientTodayWorkout({
    required this.date,
    required this.dayNumber,
    required this.isCompletedToday,
    required this.isRestDay,
    required this.exercises,
  });
}