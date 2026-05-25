import 'package:med_reability/core/services/media_url_helper.dart';

import '../../domain/entities/doctor_patient.dart';

class DoctorPatientDto {
  final String assignmentId;
  final String patientId;
  final String firstName;
  final String patronymic;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String? imageUrl;
  final bool isActive;
  final bool hasPlan;

  DoctorPatientDto({
    required this.assignmentId,
    required this.patientId,
    required this.firstName,
    required this.patronymic,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.imageUrl,
    required this.isActive,
    required this.hasPlan,
  });

  factory DoctorPatientDto.fromJson(Map<String, dynamic> json) {
    final rawImageUrl = json['imageUrl'] as String?;

    return DoctorPatientDto(
      assignmentId: (json['assignmentId'] as String?) ?? '',
      patientId: (json['patientId'] as String?) ?? '',
      firstName: (json['firstName'] as String?) ?? '',
      patronymic: (json['patronymic'] as String?) ?? '',
      lastName: (json['lastName'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      phoneNumber: (json['phoneNumber'] as String?) ?? '',
      imageUrl: rawImageUrl == null || rawImageUrl.isEmpty
          ? null
          : normalizeMediaUrl(rawImageUrl),
      isActive: (json['isActive'] as bool?) ?? false,
      hasPlan: (json['hasPlan'] as bool?) ?? false,
    );
  }

  DoctorPatient toEntity() => DoctorPatient(
    assignmentId: assignmentId,
    patientId: patientId,
    firstName: firstName,
    patronymic: patronymic,
    lastName: lastName,
    email: email,
    phoneNumber: phoneNumber,
    imageUrl: imageUrl,
    isActive: isActive,
    hasPlan: hasPlan,
  );
}