import 'package:med_reability/features/auth/domain/entities/role.dart';
import 'package:med_reability/features/auth/domain/entities/user_me.dart';

class UserMeResponse {
  final String userId;
  final String clinicId;
  final String email;
  final String role;
  final String firstName;
  final String lastName;
  final String patronymic;
  final String phoneNumber;

  const UserMeResponse({
    required this.userId,
    required this.clinicId,
    required this.email,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.patronymic,
    required this.phoneNumber,
  });

  factory UserMeResponse.fromJson(Map<String, dynamic> json) {
    return UserMeResponse(
      userId: json['userId'] as String,
      clinicId: json['clinicId'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      firstName: (json['firstName'] ?? '') as String,
      lastName: (json['lastName'] ?? '') as String,
      patronymic: (json['patronymic'] as String?) ?? '',
      phoneNumber: (json['phoneNumber'] as String?) ?? '',
    );
  }

  UserRole mapRole(String r) {
    switch (r.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'doctor':
        return UserRole.doctor;
      default:
        return UserRole.patient;
    }
  }

  UserMe toEntity() => UserMe(
    userId: userId,
    clinicId: clinicId,
    email: email,
    role: mapRole(role),
    firstName: firstName,
    lastName: lastName,
    patronymic: patronymic,
    phoneNumber: phoneNumber,
  );
}