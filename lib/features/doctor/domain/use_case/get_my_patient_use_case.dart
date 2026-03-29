import '../entities/doctor_patient.dart';
import '../repositories/doctor_patients_repository.dart';

class GetMyPatientsUseCase {
  final DoctorPatientsRepository _repo;
  const GetMyPatientsUseCase(this._repo);

  Future<List<DoctorPatient>> call() => _repo.getMyPatients();
}