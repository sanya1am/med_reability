import '../repositories/patient_program_repository.dart';

class CompletePatientTrainingDayUseCase {
  final PatientProgramRepository _repo;

  const CompletePatientTrainingDayUseCase(this._repo);

  Future<void> call({
    required String planId,
    required int dayNumber,
  }) {
    return _repo.completeDay(
      planId: planId,
      dayNumber: dayNumber,
    );
  }
}