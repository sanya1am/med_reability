import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:med_reability/core/errors/unauthorized_exception.dart';
import 'package:med_reability/core/services/token_storage.dart';
import '../../domain/entities/patient_program_overview.dart';
import '../../domain/repositories/patient_program_repository.dart';
import '../models/patient_program_overview_dto.dart';

class PatientProgramRepositoryImpl implements PatientProgramRepository {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  const PatientProgramRepositoryImpl(
      this._dio,
      this._tokenStorage,
      );

  @override
  Future<PatientProgramOverview> getOverview({
    DateTime? startDate,
    DateTime? workoutDate,
  }) async {
    try {
      final token = await _tokenStorage.readToken();

      if (token == null || token.isEmpty) {
        throw const UnauthorizedException();
      }

      final res = await _dio.get(
        '/api/patient/program-progress/me/overview',
        queryParameters: {
          if (startDate != null) 'startDate': _formatDate(startDate),
          if (workoutDate != null) 'workoutDate': _formatDate(workoutDate),
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      return PatientProgramOverviewDto
          .fromJson(res.data as Map<String, dynamic>)
          .toEntity();
    } on DioException catch (e) {
      final code = e.response?.statusCode;

      if (code == 401) throw const UnauthorizedException();
      if (code == 403) throw Exception('Недостаточно прав');
      if (code == 404) throw Exception('План реабилитации не найден');

      throw Exception('Не удалось загрузить план реабилитации');
    }
  }

  @override
  Future<void> completeExercise({
    required String planId,
    required int dayNumber,
    required String dayExerciseId,
  }) async {
    try {
      final token = await _tokenStorage.readToken();

      if (token == null || token.isEmpty) {
        throw const UnauthorizedException();
      }

      await _dio.post(
        '/api/patient/program-progress/$planId/days/$dayNumber/exercises/$dayExerciseId/complete',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode;

      if (code == 401) throw const UnauthorizedException();
      if (code == 403) throw Exception('Недостаточно прав');
      if (code == 404) throw Exception('Упражнение не найдено');

      throw Exception('Не удалось отметить упражнение выполненным');
    }
  }

  @override
  Future<void> completeDay({
    required String planId,
    required int dayNumber,
  }) async {
    try {
      final token = await _tokenStorage.readToken();

      if (token == null || token.isEmpty) {
        throw const UnauthorizedException();
      }

      await _dio.post(
        '/api/patient/program-progress/$planId/days/$dayNumber/complete',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode;

      if (code == 401) throw const UnauthorizedException();
      if (code == 403) throw Exception('Недостаточно прав');
      if (code == 404) throw Exception('Тренировочный день не найден');

      throw Exception('Не удалось завершить тренировку');
    }
  }

  @override
  Future<void> updateDayProgress({
    required String planId,
    required int dayNumber,
    required int wellBeingRating,
    required int workoutDifficultyRating,
    required bool hadPain,
    required int painIntensityRating,
  }) async {
    try {
      final token = await _tokenStorage.readToken();

      if (token == null || token.isEmpty) {
        throw const UnauthorizedException();
      }

      final body = <String, dynamic>{
        'wellBeingRating': wellBeingRating,
        'workoutDifficultyRating': workoutDifficultyRating,
        'hadPain': hadPain,
      };

      if (hadPain) {
        body['painIntensityRating'] = painIntensityRating;
      }

      await _dio.patch(
        '/api/patient/program-progress/$planId/days/$dayNumber/progress',
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode;

      debugPrint(
        'UPDATE DAY PROGRESS ERROR: '
            'status=${e.response?.statusCode}, data=${e.response?.data}',
      );

      if (code == 401) throw const UnauthorizedException();
      if (code == 403) throw Exception('Недостаточно прав');
      if (code == 404) throw Exception('Прогресс дня не найден');

      throw Exception('Не удалось сохранить оценку самочувствия');
    }
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }
}