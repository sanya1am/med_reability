import '../entities/doctor_patient_overview.dart';
import '../repositories/doctor_patient_overview_repository.dart';

class GetDoctorPatientOverviewUseCase {
  final DoctorPatientOverviewRepository _repo;

  const GetDoctorPatientOverviewUseCase(this._repo);

  Future<DoctorPatientOverview> call({
    required String patientId,
    DateTime? startDate,
  }) {
    return _repo.getPatientOverview(
      patientId: patientId,
      startDate: startDate,
    );
  }
}