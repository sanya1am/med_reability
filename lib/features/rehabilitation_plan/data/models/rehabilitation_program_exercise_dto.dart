import 'package:med_reability/features/exercises/data/models/exercise_dto.dart';

import '../../domain/entities/rehabilitation_program_exercise.dart';

class RehabilitationProgramExerciseDto {
  final String? id;
  final int order;
  final String exerciseId;
  final ExerciseDto? exercise;
  final int sets;
  final int restBetweenSetsInSeconds;
  final int restAfterInSeconds;
  final int repetitions;
  final int durationSeconds;
  final String? comment;

  const RehabilitationProgramExerciseDto({
    required this.id,
    required this.order,
    required this.exerciseId,
    required this.exercise,
    required this.sets,
    required this.restBetweenSetsInSeconds,
    required this.restAfterInSeconds,
    required this.repetitions,
    required this.durationSeconds,
    required this.comment,
  });

  factory RehabilitationProgramExerciseDto.fromJson(
      Map<String, dynamic> json,
      ) {
    final exerciseRaw = json['exerciseEntity'];

    return RehabilitationProgramExerciseDto(
      id: json['id'] as String?,
      order: (json['order'] as num?)?.toInt() ?? 0,
      exerciseId: (json['exerciseId'] as String?) ?? '',
      exercise: exerciseRaw is Map<String, dynamic>
          ? ExerciseDto.fromJson(exerciseRaw)
          : null,
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

  RehabilitationProgramExercise toEntity() {
    return RehabilitationProgramExercise(
      id: id,
      order: order,
      exerciseId: exerciseId,
      exercise: exercise?.toEntity(),
      sets: sets,
      restBetweenSetsInSeconds: restBetweenSetsInSeconds,
      restAfterInSeconds: restAfterInSeconds,
      repetitions: repetitions,
      durationSeconds: durationSeconds,
      comment: comment,
    );
  }
}