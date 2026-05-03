import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:med_reability/core/errors/unauthorized_exception.dart';
import 'package:med_reability/features/auth/data/models/user_me_response.dart';
import 'package:med_reability/features/profile/data/models/change_my_password_request.dart';

import '../../../../core/services/token_storage.dart';
import '../../../auth/domain/entities/user_me.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/update_my_profile_request.dart';


class ProfileRepositoryImpl implements ProfileRepository {
  final Dio dio;
  final TokenStorage tokenStorage;

  const ProfileRepositoryImpl(this.dio, this.tokenStorage);

  Future<Options> _authOptions({
    String? contentType,
  }) async {
    final token = await tokenStorage.readToken();
    if (token == null || token.isEmpty) throw const UnauthorizedException();

    return Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
      contentType: contentType,
    );
  }

  @override
  Future<UserMe> updateMyProfile({
    required String email,
    required String firstName,
    required String patronymic,
    required String lastName,
    required String phoneNumber,
    Uint8List? imageBytes,
    String? imageFileName,
  }) async {
    try {
      final request = UpdateMyProfileRequest(
        email: email,
        firstName: firstName,
        patronymic: patronymic,
        lastName: lastName,
        phoneNumber: phoneNumber,
        imageBytes: imageBytes,
        imageFileName: imageFileName,
      );

      final response = await dio.patch(
        '/api/auth/me/profile',
        data: request.toFormData(),
        options: await _authOptions(
          contentType: 'multipart/form-data',
        ),
      );

      return UserMeResponse.fromJson(
        response.data as Map<String, dynamic>,
      ).toEntity();
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 401) throw const UnauthorizedException();
      if (code == 403) throw Exception('Недостаточно прав');
      if (code == 404) throw Exception('Профиль не найден');
      if (code == 400) throw Exception('Некорректные данные профиля');
      throw Exception('Не удалось обновить профиль');
    }
  }

  @override
  Future<void> changeMyPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final request = ChangeMyPasswordRequest(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      await dio.patch(
        '/api/auth/me/password',
        data: request.toJson(),
        options: await _authOptions(
          contentType: Headers.jsonContentType,
        ),
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 401) throw const UnauthorizedException();
      if (code == 403) throw Exception('Недостаточно прав');
      if (code == 404) throw Exception('Пользователь не найден');
      if (code == 400) {
        throw Exception('Неверный текущий пароль или некорректный новый пароль');
      }
      throw Exception('Не удалось изменить пароль');
    }
  }
}