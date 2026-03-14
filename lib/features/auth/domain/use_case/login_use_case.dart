import '../entities/session.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repo;
  const LoginUseCase(this._repo);

  Future<AuthSession> call({
    required String email,
    required String password,
    required String clinicId,
  }) {
    return _repo.login(email: email, password: password, clinicId: clinicId);
  }
}