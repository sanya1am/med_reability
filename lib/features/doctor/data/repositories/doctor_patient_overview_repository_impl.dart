import 'package:dio/dio.dart';
import 'package:med_reability/core/errors/unauthorized_exception.dart';
import 'package:med_reability/core/services/token_storage.dart';
import '../../domain/entities/doctor_patient_overview.dart';
import '../../domain/repositories/doctor_patient_overview_repository.dart';
import '../models/doctor_patient_overview_dto.dart';


class DoctorPatientOverviewRepositoryImpl
    implements DoctorPatientOverviewRepository {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  DoctorPatientOverviewRepositoryImpl(
      this._dio,
      this._tokenStorage,
      );

  Future<Options> _authOptions() async {
    final token = await _tokenStorage.readToken();
    if (token == null || token.isEmpty) {
      throw const UnauthorizedException();
    }

    return Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  @override
  Future<DoctorPatientOverview> getPatientOverview({
    required String patientId,
    DateTime? startDate,
  }) async {
    try {
      final query = <String, dynamic>{};

      if (startDate != null) {
        query['startDate'] = _formatDate(startDate);
      }

      final res = await _dio.get(
        '/api/doctors/me/patient-overview/$patientId',
        queryParameters: query,
        options: await _authOptions(),
      );

      return DoctorPatientOverviewDto
          .fromJson(res.data as Map<String, dynamic>)
          .toEntity();
    } on DioException catch (e) {
      final code = e.response?.statusCode;

      if (code == 401) throw const UnauthorizedException();
      if (code == 403) throw Exception('Недостаточно прав');
      if (code == 404) throw Exception('Пациент не найден');

      throw Exception('Не удалось загрузить обзор пациента');
    }
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}