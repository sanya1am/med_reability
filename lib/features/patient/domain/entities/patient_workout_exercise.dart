import '../../../exercises/domain/entities/exercise.dart';

class PatientWorkoutExercise {
  final String dayExerciseId;
  final int order;
  final Exercise exercise;
  final bool isCompleted;
  final int sets;
  final int restBetweenSetsInSeconds;
  final int restAfterInSeconds;
  final int repetitions;
  final int durationSeconds;
  final String? comment;

  const PatientWorkoutExercise({
    required this.dayExerciseId,
    required this.order,
    required this.exercise,
    required this.isCompleted,
    required this.sets,
    required this.restBetweenSetsInSeconds,
    required this.restAfterInSeconds,
    required this.repetitions,
    required this.durationSeconds,
    required this.comment,
  });
}