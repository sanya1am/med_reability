import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:med_reability/core/errors/unauthorized_exception.dart';
import 'package:med_reability/core/services/token_storage.dart';
import '../../domain/entities/rehabilitation_program.dart';
import '../../domain/entities/rehabilitation_program_day.dart';
import '../../domain/entities/rehabilitation_program_exercise.dart';
import '../../domain/repositories/rehabilitation_program_repository.dart';
import '../models/rehabilitation_program_dto.dart';


class RehabilitationProgramRepositoryImpl
    implements RehabilitationProgramRepository {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  RehabilitationProgramRepositoryImpl(
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
  Future<RehabilitationProgram> createProgram({
    required String patientId,
    required String name,
    required String description,
    required DateTime startDate,
    required List<RehabilitationProgramDay> days,
  }) async {
    try {
      final payload = {
        'patientId': patientId,
        'name': name,
        'description': description,
        'startDate': _formatDate(startDate),
        'days': days.map(_dayToJson).toList(),
      };

      debugPrint('CREATE PROGRAM PAYLOAD: $payload');

      final res = await _dio.post(
        '/api/programs',
        // data: payload,
        data: {
          'patientId': patientId,
          'name': name,
          'description': description,
          'startDate': _formatDate(startDate),
          'days': days.map(_dayToJson).toList(),
        },
        options: await _authOptions(),
      );

      return RehabilitationProgramDto
          .fromJson(res.data as Map<String, dynamic>)
          .toEntity();
    } on DioException catch (e) {
      final code = e.response?.statusCode;

      if (code == 401) throw const UnauthorizedException();
      if (code == 403) throw Exception('Недостаточно прав');
      if (code == 404) throw Exception('Пациент не найден');
      if (code == 400) throw Exception(_extractError(e) ?? 'Некорректные данные плана');

      throw Exception('Не удалось создать план реабилитации');
    }
  }

  @override
  Future<RehabilitationProgram> updateProgram({
    required String id,
    required String name,
    required String description,
    required DateTime startDate,
    required List<RehabilitationProgramDay> days,
  }) async {
    try {
      final res = await _dio.put(
        '/api/programs/$id',
        data: {
          'name': name,
          'description': description,
          'startDate': _formatDate(startDate),
          'days': days.map(_dayToJson).toList(),
        },
        options: await _authOptions(),
      );

      return RehabilitationProgramDto
          .fromJson(res.data as Map<String, dynamic>)
          .toEntity();
    } on DioException catch (e) {
      final code = e.response?.statusCode;

      if (code == 401) throw const UnauthorizedException();
      if (code == 403) throw Exception('Недостаточно прав');
      if (code == 404) throw Exception('План реабилитации не найден');
      if (code == 400) throw Exception(_extractError(e) ?? 'Некорректные данные плана');

      throw Exception('Не удалось обновить план реабилитации');
    }
  }

  @override
  Future<RehabilitationProgram> getProgram({
    required String id,
  }) async {
    try {
      final res = await _dio.get(
        '/api/programs/$id',
        options: await _authOptions(),
      );

      return RehabilitationProgramDto
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
  Future<void> deleteProgram({
    required String id,
  }) async {
    try {
      await _dio.delete(
        '/api/programs/$id',
        options: await _authOptions(),
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode;

      if (code == 401) throw const UnauthorizedException();
      if (code == 403) throw Exception('Недостаточно прав');
      if (code == 404) throw Exception('План реабилитации не найден');

      throw Exception('Не удалось удалить план реабилитации');
    }
  }

  Map<String, dynamic> _dayToJson(RehabilitationProgramDay day) {
    final hasExercises = day.exercises.isNotEmpty;

    final json = <String, dynamic>{
      'dayNumber': day.dayNumber,
      'isRestDay': !hasExercises,
      'exercises': day.exercises.map(_exerciseToJson).toList(),
    };

    final notes = day.notes?.trim();
    if (notes != null && notes.isNotEmpty) {
      json['notes'] = notes;
    }

    return json;
  }

  Map<String, dynamic> _exerciseToJson(RehabilitationProgramExercise exercise) {
    final json = <String, dynamic>{
      'exerciseId': exercise.exerciseId,
      'order': exercise.order,
      'sets': exercise.sets,
    };

    if (exercise.restBetweenSetsInSeconds > 0) {
      json['restBetweenSetsInSeconds'] = exercise.restBetweenSetsInSeconds;
    }

    if (exercise.restAfterInSeconds > 0) {
      json['restAfterInSeconds'] = exercise.restAfterInSeconds;
    }

    if (exercise.repetitions > 0) {
      json['repetitions'] = exercise.repetitions;
    } else if (exercise.durationSeconds > 0) {
      json['durationSeconds'] = exercise.durationSeconds;
    }

    final comment = exercise.comment?.trim();
    if (comment != null && comment.isNotEmpty) {
      json['comment'] = comment;
    }

    return json;
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  String? _extractError(DioException e) {
    final data = e.response?.data;

    if (data is Map<String, dynamic>) {
      return data['detail'] as String? ??
          data['message'] as String? ??
          data['title'] as String?;
    }

    return null;
  }
}