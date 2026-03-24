import '../repositories/users_repository.dart';

class ActivateUserUseCase {
  final UsersRepository _repo;
  const ActivateUserUseCase(this._repo);

  Future<void> call(String userId) => _repo.activateUser(userId: userId);
}