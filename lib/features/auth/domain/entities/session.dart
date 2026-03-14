import 'clinic.dart';
import 'role.dart';

class AuthSession {
  final String token;
  final Clinic clinic;
  final UserRole role;
  final String userId;

  const AuthSession({
    required this.token,
    required this.clinic,
    required this.role,
    required this.userId,
  });
}