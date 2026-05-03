import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/errors/unauthorized_exception.dart';
import '../../../auth/domain/entities/user_me.dart';
import '../../../auth/presentation/view_model/auth_view_model.dart';
import '../../../auth/presentation/view_model/user_me_view_model.dart';
import '../state/edit_profile_state.dart';


class EditProfileViewModel extends AutoDisposeAsyncNotifier<EditProfileState> {
  late final getUserMe = ref.read(getUserMeUseCaseProvider);
  late final updateMyProfile = ref.read(updateMyProfileUseCaseProvider);
  late final changeMyPassword = ref.read(changeMyPasswordUseCaseProvider);

  @override
  Future<EditProfileState> build() async {
    try {
      final me = await getUserMe();

      if (me == null) {
        throw StateError('Не удалось загрузить профиль');
      }

      return EditProfileState.initial(me);
    } on UnauthorizedException {
      await ref.read(authViewModelProvider.notifier).logout();
      rethrow;
    }
  }

  EditProfileState get _current => state.requireValue;

  void setPickedImage({
    required Uint8List bytes,
    required String fileName,
  }) {
    state = AsyncData(
      _current.copyWith(
        pickedImageBytes: bytes,
        pickedImageFileName: fileName,
        clearErrorMessage: true,
      ),
    );
  }

  void clearPickedImage() {
    state = AsyncData(
      _current.copyWith(
        clearPickedImage: true,
        clearErrorMessage: true,
      ),
    );
  }

  Future<String?> saveProfile({
    required String firstName,
    required String patronymic,
    required String lastName,
    required String email,
    required String phoneNumber,
  }) async {
    final trimmedFirstName = firstName.trim();
    final trimmedPatronymic = patronymic.trim();
    final trimmedLastName = lastName.trim();
    final trimmedEmail = email.trim();
    final trimmedPhone = phoneNumber.trim();

    if (trimmedFirstName.isEmpty ||
        trimmedLastName.isEmpty ||
        trimmedEmail.isEmpty ||
        trimmedPhone.isEmpty) {
      return 'Заполните имя, фамилию, почту и телефон';
    }

    state = AsyncData(
      _current.copyWith(
        isSubmitting: true,
        clearErrorMessage: true,
      ),
    );

    try {
      final updated = await updateMyProfile(
        email: trimmedEmail,
        firstName: trimmedFirstName,
        patronymic: trimmedPatronymic,
        lastName: trimmedLastName,
        phoneNumber: trimmedPhone,
        imageBytes: _current.pickedImageBytes,
        imageFileName: _current.pickedImageFileName,
      );

      state = AsyncData(EditProfileState.initial(updated));
      ref.read(userMeViewModelProvider.notifier).setUser(updated);

      return null;
    } on UnauthorizedException {
      await ref.read(authViewModelProvider.notifier).logout();
      return 'Сессия истекла';
    } catch (e) {
      final message = 'Не удалось сохранить профиль: $e';

      state = AsyncData(
        _current.copyWith(
          isSubmitting: false,
          errorMessage: message,
        ),
      );

      return message;
    }
  }

  Future<String?> submitPasswordChange({
    required String currentPassword,
    required String newPassword,
  }) async {
    final current = currentPassword.trim();
    final next = newPassword.trim();

    if (current.isEmpty || next.isEmpty) {
      return 'Заполните текущий и новый пароль';
    }

    if (next.length < 6) {
      return 'Новый пароль должен содержать минимум 6 символов';
    }

    if (current == next) {
      return 'Новый пароль должен отличаться от текущего';
    }

    try {
      await changeMyPassword(
        currentPassword: current,
        newPassword: next,
      );
      return null;
    } on UnauthorizedException {
      await ref.read(authViewModelProvider.notifier).logout();
      return 'Сессия истекла';
    } catch (e) {
      return 'Не удалось изменить пароль: $e';
    }
  }
}

final editProfileViewModelProvider =
AutoDisposeAsyncNotifierProvider<EditProfileViewModel, EditProfileState>(
  EditProfileViewModel.new,
);