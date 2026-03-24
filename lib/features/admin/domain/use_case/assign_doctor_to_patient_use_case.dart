import 'package:med_reability/features/admin/domain/repositories/doctor_patient_assignments_repository.dart';

class AssignDoctorToPatientUseCase {
  final DoctorPatientAssignmentsRepository _repo;
  const AssignDoctorToPatientUseCase(this._repo);

  Future<void> call({required String patientId, required String doctorId}) {
    return _repo.assignDoctorToPatient(patientId: patientId, doctorId: doctorId);
  }
}