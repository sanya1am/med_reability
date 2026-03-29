import 'package:dio/dio.dart';
import 'package:med_reability/features/auth/data/models/user_me_response.dart';
import '../../../../core/errors/unauthorized_exception.dart';
import '../../../../core/services/token_storage.dart';
import '../../domain/entities/user_me.dart';
import '../../domain/repositories/user_me_repository.dart';


class UserMeRepositoryImpl implements UserMeRepository {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  UserMeRepositoryImpl(this._dio, this._tokenStorage);

  Future<Options> _authOptions() async {
    final token = await _tokenStorage.readToken();
    if (token == null || token.isEmpty) throw const UnauthorizedException();
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  @override
  Future<UserMe> getMe() async {
    try {
      final res = await _dio.get('/api/auth/me', options: await _authOptions());
      return UserMeResponse.fromJson(res.data as Map<String, dynamic>).toEntity();
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 401) throw const UnauthorizedException();
      if (code == 403) throw Exception('Недостаточно прав');
      throw Exception('Не удалось загрузить профиль');
    }
  }
}