import '../../../auth/domain/entities/role.dart';
import '../entities/clinic_user.dart';
import '../entities/user_image_file.dart';

class PagedResult<T> {
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final List<T> items;

  const PagedResult({
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.items,
  });
}

abstract class UsersRepository {
  Future<PagedResult<ClinicUser>> listUsers({
    required int pageNumber,
    required int pageSize,
  });

  Future<ClinicUser> createUser({
    required String email,
    required String password,
    required String firstName,
    required String patronymic,
    required String lastName,
    required String phoneNumber,
    required UserRole role,
    UserImageFile? image,
  });

  Future<void> updateUser({
    required String id,
    required String email,
    required String firstName,
    required String patronymic,
    required String lastName,
    required String phoneNumber,
    UserImageFile? image,
  });

  Future<void> deactivateUser({required String userId});
  Future<void> activateUser({required String userId});
}