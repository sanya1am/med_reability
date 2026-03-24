import '../entities/doctor_patient_assignment.dart';

abstract class DoctorPatientAssignmentsRepository {
  Future<List<DoctorPatientAssignment>> listAssignments({
    int pageSize = 200,
    String? doctorId,
    String? patientId,
    String? search,
  });

  Future<void> assignDoctorToPatient({
    required String patientId,
    required String doctorId,
  });

  Future<void> deleteAssignment({
    required String assignmentId,
  });
}