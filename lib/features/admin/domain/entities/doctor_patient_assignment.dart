import 'package:med_reability/features/admin/domain/entities/person_lite.dart';

class DoctorPatientAssignment {
  final String assignmentId;
  final PersonLite doctor;
  final PersonLite patient;

  const DoctorPatientAssignment({
    required this.assignmentId,
    required this.doctor,
    required this.patient,
  });
}