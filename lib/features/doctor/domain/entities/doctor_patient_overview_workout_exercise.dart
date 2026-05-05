import 'package:med_reability/features/exercises/domain/entities/exercise.dart';

class DoctorPatientOverviewWorkoutExercise {
  final int order;
  final Exercise exercise;
  final int sets;
  final int restBetweenSetsInSeconds;
  final int restAfterInSeconds;
  final int repetitions;
  final int durationSeconds; 
  final String? comment;

  const DoctorPatientOverviewWorkoutExercise({
    required this.order,
    required this.exercise,
    required this.sets,
    required this.restBetweenSetsInSeconds,
    required this.restAfterInSeconds,
    required this.repetitions,
    required this.durationSeconds,
    required this.comment,
  });
}