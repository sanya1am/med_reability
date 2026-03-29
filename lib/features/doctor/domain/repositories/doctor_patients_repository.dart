import '../entities/doctor_patient.dart';

abstract class DoctorPatientsRepository {
  Future<List<DoctorPatient>> getMyPatients();
}