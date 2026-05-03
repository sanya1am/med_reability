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
  final String? imageUrl;

  const UserMe({
    required this.userId,
    required this.clinicId,
    required this.email,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.patronymic,
    required this.phoneNumber,
    this.imageUrl,
  });

  String get fullName => '$lastName $firstName';

  String get fullFullName {
    final p = patronymic.trim();
    return p.isEmpty ? '$lastName $firstName' : '$lastName $firstName $p';
  }

  UserMe copyWith({
    String? userId,
    String? clinicId,
    String? email,
    UserRole? role,
    String? firstName,
    String? lastName,
    String? patronymic,
    String? phoneNumber,
    String? imageUrl,
  }) {
    return UserMe(
      userId: userId ?? this.userId,
      clinicId: clinicId ?? this.clinicId,
      email: email ?? this.email,
      role: role ?? this.role,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      patronymic: patronymic ?? this.patronymic,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}