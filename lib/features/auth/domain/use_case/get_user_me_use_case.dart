import '../entities/user_me.dart';
import '../repositories/user_me_repository.dart';

class GetUserMeUseCase {
  final UserMeRepository _repo;
  const GetUserMeUseCase(this._repo);

  Future<UserMe> call() => _repo.getMe();
}