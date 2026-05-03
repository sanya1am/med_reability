import '../repositories/profile_repository.dart';

class ChangeMyPasswordUseCase {
  final ProfileRepository repository;

  const ChangeMyPasswordUseCase(this.repository);

  Future<void> call({
    required String currentPassword,
    required String newPassword,
  }) {
    return repository.changeMyPassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}