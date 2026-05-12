import '../repositories/patient_program_repository.dart';

class CompletePatientExerciseUseCase {
  final PatientProgramRepository _repo;

  const CompletePatientExerciseUseCase(this._repo);

  Future<void> call({
    required String planId,
    required int dayNumber,
    required String dayExerciseId,
  }) {
    return _repo.completeExercise(
      planId: planId,
      dayNumber: dayNumber,
      dayExerciseId: dayExerciseId,
    );
  }
}