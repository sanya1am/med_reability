import 'package:med_reability/features/auth/domain/entities/role.dart';

import '../entities/clinic_user.dart';
import '../entities/user_image_file.dart';
import '../repositories/users_repository.dart';

class CreateUserUseCase {
  final UsersRepository _repo;
  const CreateUserUseCase(this._repo);

  Future<ClinicUser> call({
    required String email,
    required String password,
    required String firstName,
    required String patronymic,
    required String lastName,
    required String phoneNumber,
    required UserRole role,
    UserImageFile? image,
  }) {
    return _repo.createUser(
      email: email,
      password: password,
      firstName: firstName,
      patronymic: patronymic,
      lastName: lastName,
      phoneNumber: phoneNumber,
      role: role,
      image: image,
    );
  }
}