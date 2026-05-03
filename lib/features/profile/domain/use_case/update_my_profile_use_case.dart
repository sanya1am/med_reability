import 'dart:typed_data';
import '../../../auth/domain/entities/user_me.dart';
import '../repositories/profile_repository.dart';


class UpdateMyProfileUseCase {
  final ProfileRepository repository;

  const UpdateMyProfileUseCase(this.repository);

  Future<UserMe> call({
    required String email,
    required String firstName,
    required String patronymic,
    required String lastName,
    required String phoneNumber,
    Uint8List? imageBytes,
    String? imageFileName,
  }) {
    return repository.updateMyProfile(
      email: email,
      firstName: firstName,
      patronymic: patronymic,
      lastName: lastName,
      phoneNumber: phoneNumber,
      imageBytes: imageBytes,
      imageFileName: imageFileName,
    );
  }
}