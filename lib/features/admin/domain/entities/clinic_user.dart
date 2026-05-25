import 'package:med_reability/features/auth/domain/entities/role.dart';

class ClinicUser {
  final String id;
  final String clinicId;
  final String email;
  final String firstName;
  final String patronymic;
  final String lastName;
  final String phoneNumber;
  final String? imageUrl;
  final UserRole role;
  final bool isActive;
  final bool hasActivePlan;

  const ClinicUser({
    required this.id,
    required this.clinicId,
    required this.email,
    required this.firstName,
    required this.patronymic,
    required this.lastName,
    required this.phoneNumber,
    required this.imageUrl,
    required this.role,
    required this.isActive,
    required this.hasActivePlan,
  });

  String get fullName {
    final parts = [
      lastName,
      firstName,
      patronymic,
    ].where((part) => part.trim().isNotEmpty);

    return parts.join(' ');
  }
}