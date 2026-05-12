import '../entities/patient_program_overview.dart';
import '../repositories/patient_program_repository.dart';

class GetPatientProgramOverviewUseCase {
  final PatientProgramRepository _repo;

  const GetPatientProgramOverviewUseCase(this._repo);

  Future<PatientProgramOverview> call({
    DateTime? startDate,
    DateTime? workoutDate,
  }) {
    return _repo.getOverview(
      startDate: startDate,
      workoutDate: workoutDate,
    );
  }
}