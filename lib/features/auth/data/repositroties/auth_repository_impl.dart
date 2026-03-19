import 'package:dio/dio.dart';

import '../../domain/entities/clinic.dart';
import '../../domain/entities/role.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/services/token_storage.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/me_response.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  AuthRepositoryImpl(this._dio, this._tokenStorage);

  List<Clinic>? _cache;

  UserRole _mapRole(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'doctor':
        return UserRole.doctor;
      default:
        return UserRole.patient;
    }
  }

  @override
  Future<List<Clinic>> searchClinics(String query) async {
    _cache ??= await _loadClinics();
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return _cache!;
    return _cache!.where((c) => c.name.toLowerCase().contains(q)).toList();
  }

  Future<List<Clinic>> _loadClinics() async {
    try {
      final res = await _dio.get('/api/clinics');
      final data = res.data as List;

      final clinics = data.map((e) {
        final m = e as Map<String, dynamic>;
        return Clinic(
          id: m['id'] as String,
          name: m['name'] as String,
        );
      }).toList();

      return clinics;
    } on DioException catch (e) {
      throw Exception('Не удалось загрузить список клиник');
    }
  }

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
    required String clinicId,
  }) async {
    try {
      final loginRes = await _dio.post(
        '/api/auth/login',
        data: LoginRequest(
          clinicId: clinicId,
          email: email,
          password: password,
        ).toJson(),
      );

      final login = LoginResponse.fromJson(loginRes.data as Map<String, dynamic>);
      await _tokenStorage.saveToken(login.accessToken, login.expiresAtUtc);

      final meRes = await _dio.get(
        '/api/auth/me',
        options: Options(headers: {'Authorization': 'Bearer ${login.accessToken}'}),
      );

      final me = MeResponse.fromJson(meRes.data as Map<String, dynamic>);

      if (me.clinicId != clinicId) {
        throw Exception('Неверная клиника для учётных данных');
      }

      final clinics = _cache ?? await _loadClinics();
      _cache ??= clinics;

      final clinicName = clinics
          .firstWhere(
            (c) => c.id == clinicId,
        orElse: () => Clinic(id: clinicId, name: ''),
      )
          .name;

      final clinic = Clinic(id: clinicId, name: clinicName);

      return AuthSession(
        token: login.accessToken,
        clinic: clinic,
        role: _mapRole(me.role),
        userId: me.userId,
      );
    } on DioException catch (e) {
      await _tokenStorage.clear();

      final code = e.response?.statusCode;
      if (code == 401) {
        throw Exception('Неверная почта/пароль или нет доступа к клинике');
      }

      throw Exception('Ошибка сети/сервера при входе');
    }
  }

  @override
  Future<void> logout() async {
    await _tokenStorage.clear();
  }
}