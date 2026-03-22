import '../entities/clinic_user.dart';
import '../repositories/users_repository.dart';

class ListUsersUseCase {
  final UsersRepository _repo;
  const ListUsersUseCase(this._repo);

  Future<PagedResult<ClinicUser>> call({required int pageNumber, required int pageSize}) {
    return _repo.listUsers(pageNumber: pageNumber, pageSize: pageSize);
  }
}