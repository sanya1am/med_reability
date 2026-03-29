import '../../domain/entities/doctor_patient.dart';


class DoctorPatientDto {
  final String assignmentId;
  final String patientId;
  final String firstName;
  final String patronymic;
  final String lastName;
  final String email;
  final String phoneNumber;
  final bool isActive;

  DoctorPatientDto({
    required this.assignmentId,
    required this.patientId,
    required this.firstName,
    required this.patronymic,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.isActive,
  });

  factory DoctorPatientDto.fromJson(Map<String, dynamic> json) => DoctorPatientDto(
    assignmentId: (json['assignmentId'] as String?) ?? '',
    patientId: (json['patientId'] as String?) ?? '',
    firstName: (json['firstName'] as String?) ?? '',
    patronymic: (json['patronymic'] as String?) ?? '',
    lastName: (json['lastName'] as String?) ?? '',
    email: (json['email'] as String?) ?? '',
    phoneNumber: (json['phoneNumber'] as String?) ?? '',
    isActive: (json['isActive'] as bool?) ?? false,
  );

  DoctorPatient toEntity() => DoctorPatient(
    assignmentId: assignmentId,
    patientId: patientId,
    firstName: firstName,
    patronymic: patronymic,
    lastName: lastName,
    email: email,
    phoneNumber: phoneNumber,
    isActive: isActive,
  );
}