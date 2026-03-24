import 'package:med_reability/features/admin/domain/entities/person_lite.dart';
import '../../domain/entities/doctor_patient_assignment.dart';

class PersonLiteDto {
  final String id;
  final String firstName;
  final String patronymic;
  final String lastName;
  final String email;
  final String phoneNumber;
  final bool isActive;

  PersonLiteDto({
    required this.id,
    required this.firstName,
    required this.patronymic,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.isActive,
  });

  factory PersonLiteDto.fromJson(Map<String, dynamic> json) => PersonLiteDto(
    id: (json['id'] as String?) ?? '',
    firstName: (json['firstName'] as String?) ?? '',
    patronymic: (json['patronymic'] as String?) ?? '',
    lastName: (json['lastName'] as String?) ?? '',
    email: (json['email'] as String?) ?? '',
    phoneNumber: (json['phoneNumber'] as String?) ?? '',
    isActive: (json['isActive'] as bool?) ?? false,
  );

  PersonLite toEntity() => PersonLite(
    id: id,
    firstName: firstName,
    patronymic: patronymic,
    lastName: lastName,
    email: email,
    phoneNumber: phoneNumber,
    isActive: isActive,
  );
}

class DoctorPatientAssignmentDto {
  final String assignmentId;
  final PersonLiteDto doctor;
  final PersonLiteDto patient;

  DoctorPatientAssignmentDto({
    required this.assignmentId,
    required this.doctor,
    required this.patient,
  });

  factory DoctorPatientAssignmentDto.fromJson(Map<String, dynamic> json) =>
      DoctorPatientAssignmentDto(
        assignmentId: json['assignmentId'] as String,
        doctor: PersonLiteDto.fromJson(json['doctor'] as Map<String, dynamic>),
        patient: PersonLiteDto.fromJson(json['patient'] as Map<String, dynamic>),
      );

  DoctorPatientAssignment toEntity() => DoctorPatientAssignment(
    assignmentId: assignmentId,
    doctor: doctor.toEntity(),
    patient: patient.toEntity(),
  );
}