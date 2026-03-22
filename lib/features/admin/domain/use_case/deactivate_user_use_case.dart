import '../repositories/users_repository.dart';

class DeactivateUserUseCase {
  final UsersRepository _repo;
  const DeactivateUserUseCase(this._repo);

  Future<void> call(String userId) => _repo.deactivateUser(userId: userId);
}