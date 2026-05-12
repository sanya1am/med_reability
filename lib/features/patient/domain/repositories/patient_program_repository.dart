import '../entities/patient_program_overview.dart';

abstract class PatientProgramRepository {
  Future<PatientProgramOverview> getOverview({
    DateTime? startDate,
    DateTime? workoutDate,
  });

  Future<void> completeExercise({
    required String planId,
    required int dayNumber,
    required String dayExerciseId,
  });

  Future<void> completeDay({
    required String planId,
    required int dayNumber,
  });

  Future<void> updateDayProgress({
    required String planId,
    required int dayNumber,
    required int wellBeingRating,
    required int workoutDifficultyRating,
    required bool hadPain,
    required int painIntensityRating,
  });
}