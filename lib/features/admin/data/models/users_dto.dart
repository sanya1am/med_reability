import 'package:med_reability/features/auth/domain/entities/role.dart';
import '../../domain/entities/clinic_user.dart';
import '../../domain/repositories/users_repository.dart';

UserRole _mapRole(String r) {
  switch (r.toLowerCase()) {
    case 'admin':
      return UserRole.admin;
    case 'doctor':
      return UserRole.doctor;
    case 'patient':
      return UserRole.patient;
    default:
      return UserRole.patient;
  }
}

String _roleToApi(UserRole role) {
  switch (role) {
    case UserRole.admin:
      return 'Admin';
    case UserRole.doctor:
      return 'Doctor';
    case UserRole.patient:
      return 'Patient';
  }
}

class ClinicUserDto {
  final String id;
  final String clinicId;
  final String email;
  final String firstName;
  final String patronymic;
  final String lastName;
  final String role;
  final String phoneNumber;
  final bool isActive;

  ClinicUserDto({
    required this.id,
    required this.clinicId,
    required this.email,
    required this.firstName,
    required this.patronymic,
    required this.lastName,
    required this.role,
    required this.phoneNumber,
    required this.isActive,
  });

  factory ClinicUserDto.fromJson(Map<String, dynamic> json) => ClinicUserDto(
    id: json['id'] as String,
    clinicId: json['clinicId'] as String,
    email: json['email'] as String,
    firstName: (json['firstName'] ?? '') as String,
    patronymic: (json['patronymic'] ?? '') as String,
    lastName: (json['lastName'] ?? '') as String,
    role: (json['role'] ?? '') as String,
    phoneNumber: (json['phoneNumber'] ?? '') as String,
    isActive: (json['isActive'] ?? false) as bool,
  );

  ClinicUser toEntity() => ClinicUser(
    id: id,
    clinicId: clinicId,
    email: email,
    firstName: firstName,
    lastName: lastName,
    role: _mapRole(role),
    isActive: isActive,
  );
}

class UsersPageDto {
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final List<ClinicUserDto> items;

  UsersPageDto({
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.items,
  });

  factory UsersPageDto.fromJson(Map<String, dynamic> json) => UsersPageDto(
    pageNumber: (json['pageNumber'] ?? 1) as int,
    pageSize: (json['pageSize'] ?? 10) as int,
    totalCount: (json['totalCount'] ?? 0) as int,
    items: ((json['items'] ?? []) as List)
        .map((e) => ClinicUserDto.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  PagedResult<ClinicUser> toDomain() => PagedResult(
    pageNumber: pageNumber,
    pageSize: pageSize,
    totalCount: totalCount,
    items: items.map((e) => e.toEntity()).toList(),
  );
}

Map<String, dynamic> createUserBody({
  required String email,
  required String password,
  required String firstName,
  required String patronymic,
  required String lastName,
  required String phoneNumber,
  required UserRole role,
}) {
  return {
    'email': email,
    'password': password,
    'firstName': firstName,
    'patronymic': patronymic,
    'lastName': lastName,
    'phoneNumber': phoneNumber,
    'role': _roleToApi(role),
  };
}