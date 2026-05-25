import 'package:dio/dio.dart';
import 'package:med_reability/core/errors/unauthorized_exception.dart';
import 'package:med_reability/features/auth/domain/entities/role.dart';
import '../../../../core/services/token_storage.dart';
import '../../domain/entities/clinic_user.dart';
import '../../domain/entities/user_image_file.dart';
import '../../domain/repositories/users_repository.dart';
import '../models/users_dto.dart';

class UsersRepositoryImpl implements UsersRepository {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  UsersRepositoryImpl(this._dio, this._tokenStorage);

  Future<Options> _authOptions({String? contentType}) async {
    final token = await _tokenStorage.readToken();
    if (token == null || token.isEmpty) {
      throw Exception('Нет токена. Выполните вход заново.');
    }
    return Options(
      headers: {'Authorization': 'Bearer $token'},
      contentType: contentType,
    );
  }

  @override
  Future<PagedResult<ClinicUser>> listUsers({
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      final res = await _dio.get(
        '/api/users',
        queryParameters: {
          'PageNumber': pageNumber,
          'PageSize': pageSize,
        },
        options: await _authOptions(),
      );

      final dto = UsersPageDto.fromJson(res.data as Map<String, dynamic>);
      return dto.toDomain();
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 401) throw const UnauthorizedException();
      if (code == 403) throw Exception('Недостаточно прав.');
      throw Exception('Не удалось загрузить пользователей');
    }
  }

  @override
  Future<ClinicUser> createUser({
    required String email,
    required String password,
    required String firstName,
    required String patronymic,
    required String lastName,
    required String phoneNumber,
    required UserRole role,
    UserImageFile? image,
  }) async {
    try {
      final formData = FormData.fromMap({
        'email': email,
        'password': password,
        'firstName': firstName,
        'patronymic': patronymic,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'role': role.name,
        if (image != null)
          'image': MultipartFile.fromBytes(
            image.bytes,
            filename: image.name,
          ),
      });
      final res = await _dio.post(
        '/api/users',
        data: formData,
        options: await _authOptions(
          contentType: 'multipart/form-data',
        ),
      );

      final dto = ClinicUserDto.fromJson(res.data as Map<String, dynamic>);
      return dto.toEntity();
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      final data = e.response?.data;

      print('createUser status: $code');
      print('createUser data: $data');
      print('createUser message: ${e.message}');

      if (code == 400) throw Exception(_problemDetail(data));
      if (code == 401) throw const UnauthorizedException();
      if (code == 403) throw Exception('Недостаточно прав.');
      throw Exception('Не удалось создать пользователя');
    }
  }

  @override
  Future<void> updateUser({
    required String id,
    required String email,
    required String firstName,
    required String patronymic,
    required String lastName,
    required String phoneNumber,
    UserImageFile? image,
  }) async {
    final formData = FormData.fromMap({
      'Email': email,
      'FirstName': firstName,
      'Patronymic': patronymic,
      'LastName': lastName,
      'PhoneNumber': phoneNumber,
      if (image != null)
        'Image': MultipartFile.fromBytes(
          image.bytes,
          filename: image.name,
        ),
    });

    await _dio.put(
      '/api/users/$id',
      data: formData,
      options: await _authOptions(
        contentType: 'multipart/form-data',
      ),
    );
  }

  @override
  Future<void> deactivateUser({required String userId}) async {
    try {
      await _dio.patch(
        '/api/users/$userId/deactivate',
        options: await _authOptions(),
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 401) throw const UnauthorizedException();
      if (code == 403) throw Exception('Недостаточно прав.');
      if (code == 404) throw Exception('Пользователь не найден');
      throw Exception('Не удалось деактивировать пользователя');
    }
  }

  @override
  Future<void> activateUser({required String userId}) async {
    try {
      await _dio.patch(
        '/api/users/$userId/activate',
        options: await _authOptions(),
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 401) throw const UnauthorizedException();
      if (code == 403) throw Exception('Недостаточно прав.');
      if (code == 404) throw Exception('Пользователь не найден');
      throw Exception('Не удалось активировать пользователя');
    }
  }

  String _problemDetail(dynamic data) {
    if (data is Map<String, dynamic>) {
      final detail = data['detail'];
      if (detail is String && detail.isNotEmpty) return detail;

      final title = data['title'];
      if (title is String && title.isNotEmpty) return title;
    }
    return 'Некорректные данные пользователя';
  }
}