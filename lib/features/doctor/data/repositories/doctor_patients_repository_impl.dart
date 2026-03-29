import 'package:dio/dio.dart';
import '../../../../core/errors/unauthorized_exception.dart';
import '../../../../core/services/token_storage.dart';
import '../../domain/entities/doctor_patient.dart';
import '../../domain/repositories/doctor_patients_repository.dart';
import '../models/doctor_patient_dto.dart';


class DoctorPatientsRepositoryImpl implements DoctorPatientsRepository {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  DoctorPatientsRepositoryImpl(this._dio, this._tokenStorage);

  Future<Options> _authOptions() async {
    final token = await _tokenStorage.readToken();
    if (token == null || token.isEmpty) throw const UnauthorizedException();
    return Options(headers: {'Authorization': 'Bearer $token'});
  }

  @override
  Future<List<DoctorPatient>> getMyPatients() async {
    try {
      final res = await _dio.get(
        '/api/doctors/me/patients',
        options: await _authOptions(),
      );

      final list = (res.data as List)
          .map((e) => DoctorPatientDto.fromJson(e as Map<String, dynamic>).toEntity())
          .toList();

      return list;
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 401) throw const UnauthorizedException();
      if (code == 403) throw Exception('Недостаточно прав');
      throw Exception('Не удалось загрузить пациентов');
    }
  }
}