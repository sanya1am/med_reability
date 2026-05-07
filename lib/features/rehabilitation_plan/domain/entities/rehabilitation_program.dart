import 'rehabilitation_program_day.dart';

class RehabilitationProgram {
  final String id;
  final String clinicId;
  final String patientId;
  final String createdByUserId;
  final String name;
  final String description;
  final DateTime startDate;
  final String status;
  final bool isDeleted;
  final List<RehabilitationProgramDay> days;

  const RehabilitationProgram({
    required this.id,
    required this.clinicId,
    required this.patientId,
    required this.createdByUserId,
    required this.name,
    required this.description,
    required this.startDate,
    required this.status,
    required this.isDeleted,
    required this.days,
  });
}