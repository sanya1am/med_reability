import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/core/di/providers.dart';
import 'package:med_reability/core/errors/unauthorized_exception.dart';
import 'package:med_reability/features/admin/domain/entities/clinic_user.dart';
import 'package:med_reability/features/admin/domain/entities/user_image_file.dart';
import 'package:med_reability/features/admin/presentation/state/user_form_state.dart';
import 'package:med_reability/features/auth/domain/entities/role.dart';
import 'package:med_reability/features/auth/presentation/view_model/auth_view_model.dart';

import '../../../../utils/validation/password_validator.dart';

class UserFormViewModel
    extends AutoDisposeFamilyNotifier<UserFormState, ClinicUser?> {
  late final _createUser = ref.read(createUserUseCaseProvider);
  late final _updateUser = ref.read(updateUserUseCaseProvider);

  late ClinicUser? _initialUser;

  @override
  UserFormState build(ClinicUser? arg) {
    _initialUser = arg;

    return UserFormState(
      isEdit: arg != null,
      role: arg?.role ?? UserRole.patient,
      image: null,
      isSubmitting: false,
      errorMessage: null,
    );
  }

  void setRole(UserRole role) {
    state = state.copyWith(
      role: role,
      clearError: true,
    );
  }

  void setImage(UserImageFile image) {
    state = state.copyWith(
      image: image,
      clearError: true,
    );
  }

  Future<bool> submit({
    required String email,
    required String password,
    required String firstName,
    required String patronymic,
    required String lastName,
    required String phoneNumber,
  }) async {
    if (state.isSubmitting) return false;

    final trimmedEmail = email.trim();
    final trimmedFirstName = firstName.trim();
    final trimmedLastName = lastName.trim();
    final trimmedPatronymic = patronymic.trim();
    final trimmedPhone = phoneNumber.trim();

    if (trimmedLastName.isEmpty ||
        trimmedFirstName.isEmpty ||
        trimmedEmail.isEmpty ||
        trimmedPhone.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Заполните обязательные поля',
      );
      return false;
    }

    if (!state.isEdit) {
      final passwordValidation = PasswordValidator.validate(password);

      if (!passwordValidation.isValid) {
        state = state.copyWith(
          errorMessage: passwordValidation.errorText,
        );
        return false;
      }
    }

    state = state.copyWith(
      isSubmitting: true,
      clearError: true,
    );

    final result = await AsyncValue.guard(() async {
      if (state.isEdit) {
        final user = _initialUser;
        if (user == null) {
          throw Exception('Не найден пользователь для редактирования');
        }

        await _updateUser(
          id: user.id,
          email: trimmedEmail,
          firstName: trimmedFirstName,
          patronymic: trimmedPatronymic,
          lastName: trimmedLastName,
          phoneNumber: trimmedPhone,
          image: state.image,
        );

        return;
      }

      await _createUser(
        email: trimmedEmail,
        password: password,
        firstName: trimmedFirstName,
        patronymic: trimmedPatronymic,
        lastName: trimmedLastName,
        phoneNumber: trimmedPhone,
        role: state.role,
        image: state.image,
      );
    });

    if (result.hasError) {
      final error = result.error;

      if (error is UnauthorizedException) {
        await ref.read(authViewModelProvider.notifier).logout();
        return false;
      }

      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.toString(),
      );

      return false;
    }

    state = state.copyWith(
      isSubmitting: false,
      clearError: true,
    );

    return true;
  }
}

final userFormViewModelProvider = NotifierProvider.autoDispose.family<
    UserFormViewModel,
    UserFormState,
    ClinicUser?>(
  UserFormViewModel.new,
);