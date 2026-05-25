import 'package:med_reability/features/admin/domain/entities/user_image_file.dart';
import 'package:med_reability/features/admin/domain/repositories/users_repository.dart';

class UpdateUserUseCase {
  final UsersRepository _repo;
  const UpdateUserUseCase(this._repo);

  Future<void> call({
    required String id,
    required String email,
    required String firstName,
    required String patronymic,
    required String lastName,
    required String phoneNumber,
    UserImageFile? image,
  }) {
    return _repo.updateUser(
      id: id,
      email: email,
      firstName: firstName,
      patronymic: patronymic,
      lastName: lastName,
      phoneNumber: phoneNumber,
      image: image,
    );
  }
}