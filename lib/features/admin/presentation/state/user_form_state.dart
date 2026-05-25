import 'package:med_reability/features/admin/domain/entities/user_image_file.dart';
import 'package:med_reability/features/auth/domain/entities/role.dart';

class UserFormState {
  final bool isEdit;
  final UserRole role;
  final UserImageFile? image;
  final bool isSubmitting;
  final String? errorMessage;

  const UserFormState({
    required this.isEdit,
    required this.role,
    required this.image,
    required this.isSubmitting,
    required this.errorMessage,
  });

  UserFormState copyWith({
    bool? isEdit,
    UserRole? role,
    UserImageFile? image,
    bool clearImage = false,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return UserFormState(
      isEdit: isEdit ?? this.isEdit,
      role: role ?? this.role,
      image: clearImage ? null : image ?? this.image,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}