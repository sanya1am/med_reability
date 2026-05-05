import '../entities/doctor_patient_overview.dart';

abstract class DoctorPatientOverviewRepository {
  Future<DoctorPatientOverview> getPatientOverview({
    required String patientId,
    DateTime? startDate,
  });
}