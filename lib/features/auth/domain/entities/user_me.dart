import 'role.dart';

class UserMe {
  final String userId;
  final String clinicId;
  final String email;
  final UserRole role;
  final String firstName;
  final String lastName;
  final String patronymic;
  final String phoneNumber;

  const UserMe({
    required this.userId,
    required this.clinicId,
    required this.email,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.patronymic,
    required this.phoneNumber,
  });

  String get fullName => '$lastName $firstName';

  String get fullFullName {
    final p = patronymic.trim();
    return p.isEmpty ? '$lastName $firstName' : '$lastName $firstName $p';
  }
}