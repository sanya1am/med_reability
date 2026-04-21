import 'package:dio/dio.dart';
import '../../../../core/errors/unauthorized_exception.dart';
import '../../../../core/services/token_storage.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/exercise_media_file.dart';
import '../../domain/entities/exercise_type.dart';
import '../../domain/repositories/exercises_repository.dart';
import '../models/exercise_dto.dart';


class ExercisesRepositoryImpl implements ExercisesRepository {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  ExercisesRepositoryImpl(this._dio, this._tokenStorage);

  Future<Options> _authOptions() async {
    final token = await _tokenStorage.readToken();
    if (token == null || token.isEmpty) throw const UnauthorizedException();
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  @override
  Future<List<Exercise>> getExercises({
    required int pageNumber,
    required int pageSize,
    required bool all,
    String? search,
    List<ExerciseType>? types,
  }) async {
    try {
      final query = <String, dynamic>{
        'PageNumber': pageNumber,
        'PageSize': pageSize,
        'All': all,
      };

      if (search != null && search.trim().isNotEmpty) {
        query['Search'] = search.trim();
      }

      final apiTypes = (types ?? const <ExerciseType>[])
          .map(exerciseTypeToApi)
          .toList();

      if (apiTypes.isNotEmpty) {
        query['Types'] = apiTypes;
      }

      final res = await _dio.get(
        '/api/exercises',
        queryParameters: query,
        options: await _authOptions(),
      );

      final data = res.data as Map<String, dynamic>;
      final itemsRaw = (data['items'] as List?) ?? const [];

      return itemsRaw
          .map((e) => ExerciseDto.fromJson(e as Map<String, dynamic>).toEntity())
          .where((x) => !x.isDeleted)
          .toList();
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 401) throw const UnauthorizedException();
      if (code == 403) throw Exception('Недостаточно прав');
      throw Exception('Не удалось загрузить упражнения');
    }
  }

  @override
  Future<Exercise> getExerciseById(String id) async {
    try {
      final res = await _dio.get(
        '/api/exercises/$id',
        options: await _authOptions(),
      );

      return ExerciseDto.fromJson(res.data as Map<String, dynamic>).toEntity();
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 401) throw const UnauthorizedException();
      if (code == 403) throw Exception('Недостаточно прав');
      if (code == 404) throw Exception('Упражнение не найдено');
      throw Exception('Не удалось загрузить упражнение');
    }
  }

  @override
  Future<Exercise> createExercise({
    required String name,
    required String description,
    required List<String> steps,
    required ExerciseType type,
    required bool isGlobal,
    List<ExerciseMediaFile> mediaFiles = const [],
  }) async {
    try {
      final fd = FormData();

      fd.fields
        ..add(MapEntry('Name', name))
        ..add(MapEntry('Description', description))
        ..add(MapEntry('Type', exerciseTypeToApi(type)))
        ..add(MapEntry('IsGlobal', isGlobal.toString()));

      for (final s in steps.where((x) => x.trim().isNotEmpty)) {
        fd.fields.add(MapEntry('Steps', s));
      }

      for (final file in mediaFiles) {
        fd.files.add(
          MapEntry(
            'MediaFiles',
            MultipartFile.fromBytes(
              file.bytes,
              filename: file.name,
            ),
          ),
        );
      }

      final res = await _dio.post(
        '/api/exercises',
        data: fd,
        options: (await _authOptions()).copyWith(
          contentType: 'multipart/form-data',
        ),
      );

      return ExerciseDto.fromJson(res.data as Map<String, dynamic>).toEntity();
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 401) throw const UnauthorizedException();
      if (code == 403) throw Exception('Недостаточно прав');
      if (code == 400) throw Exception('Некорректные данные упражнения');
      throw Exception('Не удалось создать упражнение');
    }
  }

  @override
  Future<Exercise> updateExercise({
    required String id,
    required String name,
    required String description,
    required List<String> steps,
    required ExerciseType type,
    List<ExerciseMediaFile> mediaFiles = const [],
  }) async {
    try {
      final fd = FormData();

      fd.fields
        ..add(MapEntry('Name', name))
        ..add(MapEntry('Description', description))
        ..add(MapEntry('Type', exerciseTypeToApi(type)));

      for (final s in steps.where((x) => x.trim().isNotEmpty)) {
        fd.fields.add(MapEntry('Steps', s));
      }

      for (final file in mediaFiles) {
        fd.files.add(
          MapEntry(
            'MediaFiles',
            MultipartFile.fromBytes(
              file.bytes,
              filename: file.name,
            ),
          ),
        );
      }

      final res = await _dio.put(
        '/api/exercises/$id',
        data: fd,
        options: (await _authOptions()).copyWith(
          contentType: 'multipart/form-data',
        ),
      );

      return ExerciseDto.fromJson(res.data as Map<String, dynamic>).toEntity();
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 401) throw const UnauthorizedException();
      if (code == 403) throw Exception('Недостаточно прав');
      if (code == 404) throw Exception('Упражнение не найдено');
      if (code == 400) {
        final detail = e.response?.data is Map<String, dynamic>
            ? (e.response?.data['detail'] as String?)
            : null;
        throw Exception(detail ?? 'Некорректные данные упражнения');
      }
      throw Exception('Не удалось обновить упражнение');
    }
  }

  @override
  Future<void> deleteExercise(String id) async {
    try {
      await _dio.delete('/api/exercises/$id', options: await _authOptions());
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 401) throw const UnauthorizedException();
      if (code == 403) throw Exception('Недостаточно прав');
      if (code == 404) throw Exception('Упражнение не найдено');
      throw Exception('Не удалось удалить упражнение');
    }
  }
}