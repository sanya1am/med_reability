import 'package:med_reability/features/exercises/data/models/exercise_dto.dart';
import '../../domain/entities/doctor_patient_overview_workout_exercise.dart';

class DoctorPatientOverviewWorkoutExerciseDto {
  final int order;
  final ExerciseDto exercise;
  final int sets;
  final int restBetweenSetsInSeconds;
  final int restAfterInSeconds;
  final int repetitions;
  final int durationSeconds;
  final String? comment;

  const DoctorPatientOverviewWorkoutExerciseDto({
    required this.order,
    required this.exercise,
    required this.sets,
    required this.restBetweenSetsInSeconds,
    required this.restAfterInSeconds,
    required this.repetitions,
    required this.durationSeconds,
    required this.comment,
  });

  factory DoctorPatientOverviewWorkoutExerciseDto.fromJson(
      Map<String, dynamic> json,
      ) {
    final exerciseRaw = json['exerciseEntity'];

    return DoctorPatientOverviewWorkoutExerciseDto(
      order: (json['order'] as num?)?.toInt() ?? 0,
      exercise: ExerciseDto.fromJson(
        exerciseRaw is Map<String, dynamic> ? exerciseRaw : const {},
      ),
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

  DoctorPatientOverviewWorkoutExercise toEntity() {
    return DoctorPatientOverviewWorkoutExercise(
      order: order,
      exercise: exercise.toEntity(),
      sets: sets,
      restBetweenSetsInSeconds: restBetweenSetsInSeconds,
      restAfterInSeconds: restAfterInSeconds,
      repetitions: repetitions,
      durationSeconds: durationSeconds,
      comment: comment,
    );
  }
}