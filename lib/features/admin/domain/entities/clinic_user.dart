import 'package:med_reability/features/auth/domain/entities/role.dart';

class ClinicUser {
  final String id;
  final String clinicId;
  final String email;
  final String firstName;
  final String lastName;
  final UserRole role;
  final bool isActive;

  const ClinicUser({
    required this.id,
    required this.clinicId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.isActive,
  });

  String get fullName => ('$lastName $firstName').trim();
}