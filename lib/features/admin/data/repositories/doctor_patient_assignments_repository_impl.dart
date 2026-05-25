import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/errors/unauthorized_exception.dart';
import '../../../../core/services/token_storage.dart';
import '../../domain/entities/doctor_patient_assignment.dart';
import '../../domain/repositories/doctor_patient_assignments_repository.dart';
import '../models/doctor_patient_assignment_dto.dart';

class DoctorPatientAssignmentsRepositoryImpl implements DoctorPatientAssignmentsRepository {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  DoctorPatientAssignmentsRepositoryImpl(this._dio, this._tokenStorage);

  Future<Options> _authOptions() async {
    final token = await _tokenStorage.readToken();
    if (token == null || token.isEmpty) throw const UnauthorizedException();
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  @override
  Future<List<DoctorPatientAssignment>> listAssignments({
    int pageSize = 200,
    String? doctorId,
    String? patientId,
    String? search,
  }) async {
    final List<DoctorPatientAssignment> all = [];
    var pageNumber = 1;
    int totalCount = 0;

    while (true) {
      try {
        final res = await _dio.get(
          '/api/doctor-patient-assignments',
          queryParameters: {
            'PageNumber': pageNumber,
            'PageSize': pageSize,
            if (doctorId != null) 'DoctorId': doctorId,
            if (patientId != null) 'PatientId': patientId,
            if (search != null && search.trim().isNotEmpty) 'Search': search.trim(),
          },
          options: await _authOptions(),
        );

        final data = res.data as Map<String, dynamic>;
        totalCount = (data['totalCount'] ?? 0) as int;
        final items = ((data['items'] ?? []) as List)
            .map((e) => DoctorPatientAssignmentDto.fromJson(e as Map<String, dynamic>).toEntity())
            .toList();

        all.addAll(items);

        if (all.length >= totalCount || items.isEmpty) break;
        pageNumber += 1;
      } on DioException catch (e) {
        final code = e.response?.statusCode;
        if (code == 401) throw const UnauthorizedException();
        if (code == 403) throw Exception('Недостаточно прав');
        throw Exception('Не удалось загрузить назначения');
      }
    }

    return all;
  }

  @override
  Future<void> assignDoctorToPatient({required String patientId, required String doctorId}) async {
    try {
      await _dio.post(
        '/api/doctor-patient-assignments/assign-doctor-to-patient',
        data: {'patientId': patientId, 'doctorId': doctorId},
        options: await _authOptions(),
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 401) throw const UnauthorizedException();
      if (code == 403) throw Exception('Недостаточно прав');
      if (code == 404) throw Exception('Доктор или пациент не найден');
      throw Exception('Не удалось назначить инструктора');
    }
  }

  @override
  Future<void> deleteAssignment({required String assignmentId}) async {
    try {
      debugPrint('deleteAssignment assignmentId: $assignmentId');

      await _dio.delete(
        '/api/doctor-patient-assignments/$assignmentId',
        options: await _authOptions(),
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      final data = e.response?.data;

      debugPrint('deleteAssignment status: $code');
      debugPrint('deleteAssignment data: $data');
      debugPrint('deleteAssignment message: ${e.message}');
      debugPrint('deleteAssignment error: ${e.error}');

      if (code == 401) throw const UnauthorizedException();
      if (code == 403) throw Exception('Недостаточно прав');
      if (code == 404) throw Exception('Назначение не найдено');

      if (data is Map<String, dynamic>) {
        final detail = data['detail'];
        final title = data['title'];

        if (detail is String && detail.isNotEmpty) {
          throw Exception(detail);
        }

        if (title is String && title.isNotEmpty) {
          throw Exception(title);
        }
      }

      throw Exception('Не удалось снять назначение');
    }
  }
}