import '../repositories/patient_program_repository.dart';

class UpdatePatientDayProgressUseCase {
  final PatientProgramRepository _repo;

  const UpdatePatientDayProgressUseCase(this._repo);

  Future<void> call({
    required String planId,
    required int dayNumber,
    required int wellBeingRating,
    required int workoutDifficultyRating,
    required bool hadPain,
    required int painIntensityRating,
  }) {
    return _repo.updateDayProgress(
      planId: planId,
      dayNumber: dayNumber,
      wellBeingRating: wellBeingRating,
      workoutDifficultyRating: workoutDifficultyRating,
      hadPain: hadPain,
      painIntensityRating: painIntensityRating,
    );
  }
}