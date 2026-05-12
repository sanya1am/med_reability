import '../../../exercises/data/models/exercise_dto.dart';
import '../../domain/entities/patient_workout_exercise.dart';

class PatientWorkoutExerciseDto {
  final String dayExerciseId;
  final int order;
  final ExerciseDto exercise;
  final bool isCompleted;
  final int sets;
  final int restBetweenSetsInSeconds;
  final int restAfterInSeconds;
  final int repetitions;
  final int durationSeconds;
  final String? comment;

  const PatientWorkoutExerciseDto({
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

  factory PatientWorkoutExerciseDto.fromJson(Map<String, dynamic> json) {
    return PatientWorkoutExerciseDto(
      dayExerciseId: json['dayExerciseId'] as String? ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
      exercise: ExerciseDto.fromJson(
        json['exerciseEntity'] as Map<String, dynamic>,
      ),
      isCompleted: json['isCompleted'] as bool? ?? false,
      sets: (json['sets'] as num?)?.toInt() ?? 0,
      restBetweenSetsInSeconds:
      (json['restBetweenSetsInSeconds'] as num?)?.toInt() ?? 0,
      restAfterInSeconds:
      (json['restAfterInSeconds'] as num?)?.toInt() ?? 0,
      repetitions: (json['repetitions'] as num?)?.toInt() ?? 0,
      durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
      comment: json['comment'] as String?,
    );
  }

  PatientWorkoutExercise toEntity() {
    return PatientWorkoutExercise(
      dayExerciseId: dayExerciseId,
      order: order,
      exercise: exercise.toEntity(),
      isCompleted: isCompleted,
      sets: sets,
      restBetweenSetsInSeconds: restBetweenSetsInSeconds,
      restAfterInSeconds: restAfterInSeconds,
      repetitions: repetitions,
      durationSeconds: durationSeconds,
      comment: comment,
    );
  }
}