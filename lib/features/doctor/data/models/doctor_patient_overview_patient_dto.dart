import 'package:med_reability/core/services/media_url_helper.dart';
import '../../domain/entities/doctor_patient_overview_patient.dart';

class DoctorPatientOverviewPatientDto {
  final String id;
  final String clinicId;
  final String firstName;
  final String? patronymic;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String? imageUrl;
  final bool isActive;

  const DoctorPatientOverviewPatientDto({
    required this.id,
    required this.clinicId,
    required this.firstName,
    required this.patronymic,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.imageUrl,
    required this.isActive,
  });

  factory DoctorPatientOverviewPatientDto.fromJson(Map<String, dynamic> json) {
    final rawImageUrl = json['imageUrl'] as String?;

    return DoctorPatientOverviewPatientDto(
      id: (json['id'] as String?) ?? '',
      clinicId: (json['clinicId'] as String?) ?? '',
      firstName: (json['firstName'] as String?) ?? '',
      patronymic: json['patronymic'] as String?,
      lastName: (json['lastName'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      phoneNumber: (json['phoneNumber'] as String?) ?? '',
      imageUrl: rawImageUrl == null || rawImageUrl.isEmpty
          ? null
          : normalizeMediaUrl(rawImageUrl),
      isActive: (json['isActive'] as bool?) ?? false,
    );
  }

  DoctorPatientOverviewPatient toEntity() {
    return DoctorPatientOverviewPatient(
      id: id,
      clinicId: clinicId,
      firstName: firstName,
      patronymic: patronymic,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      imageUrl: imageUrl,
      isActive: isActive,
    );
  }
}