import 'package:med_reability/features/admin/domain/entities/doctor_patient_assignment.dart';
import 'package:med_reability/features/admin/domain/repositories/doctor_patient_assignments_repository.dart';

class GetAssignmentsUseCase {
  final DoctorPatientAssignmentsRepository _repo;
  const GetAssignmentsUseCase(this._repo);

  Future<List<DoctorPatientAssignment>> call({
    int pageSize = 200,
    String? doctorId,
    String? patientId,
    String? search,
  }) {
    return _repo.listAssignments(
      pageSize: pageSize,
      doctorId: doctorId,
      patientId: patientId,
      search: search,
    );
  }
}