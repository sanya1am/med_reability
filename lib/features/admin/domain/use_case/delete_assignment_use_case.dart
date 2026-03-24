import '../repositories/doctor_patient_assignments_repository.dart';

class DeleteAssignmentUseCase {
  final DoctorPatientAssignmentsRepository _repo;
  const DeleteAssignmentUseCase(this._repo);

  Future<void> call(String assignmentId) {
    return _repo.deleteAssignment(assignmentId: assignmentId);
  }
}