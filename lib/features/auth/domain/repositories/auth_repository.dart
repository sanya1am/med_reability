import '../entities/clinic.dart';
import '../entities/session.dart';

abstract class AuthRepository {
  Future<List<Clinic>> searchClinics(String query);

  Future<AuthSession> login({
    required String email,
    required String password,
    required String clinicId,
  });

  Future<void> logout();
}