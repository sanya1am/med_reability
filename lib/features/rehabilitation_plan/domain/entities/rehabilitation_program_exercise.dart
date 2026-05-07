import 'package:med_reability/features/exercises/domain/entities/exercise.dart';

class RehabilitationProgramExercise {
  final String? id;
  final int order;
  final String exerciseId;
  final Exercise? exercise;
  final int sets;
  final int restBetweenSetsInSeconds;
  final int restAfterInSeconds;
  final int repetitions;
  final int durationSeconds;
  final String? comment;

  const RehabilitationProgramExercise({
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

  RehabilitationProgramExercise copyWith({
    String? id,
    int? order,
    String? exerciseId,
    Exercise? exercise,
    int? sets,
    int? restBetweenSetsInSeconds,
    int? restAfterInSeconds,
    int? repetitions,
    int? durationSeconds,
    String? comment,
  }) {
    return RehabilitationProgramExercise(
      id: id ?? this.id,
      order: order ?? this.order,
      exerciseId: exerciseId ?? this.exerciseId,
      exercise: exercise ?? this.exercise,
      sets: sets ?? this.sets,
      restBetweenSetsInSeconds:
      restBetweenSetsInSeconds ?? this.restBetweenSetsInSeconds,
      restAfterInSeconds: restAfterInSeconds ?? this.restAfterInSeconds,
      repetitions: repetitions ?? this.repetitions,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      comment: comment ?? this.comment,
    );
  }
}