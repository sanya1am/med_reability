import '../../domain/entities/doctor_patient_overview_plan.dart';

class DoctorPatientOverviewPlanDto {
  final String id;
  final String name;
  final String status;
  final DateTime startDate;

  const DoctorPatientOverviewPlanDto({
    required this.id,
    required this.name,
    required this.status,
    required this.startDate,
  });

  factory DoctorPatientOverviewPlanDto.fromJson(Map<String, dynamic> json) {
    return DoctorPatientOverviewPlanDto(
      id: (json['id'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      status: (json['status'] as String?) ?? '',
      startDate: DateTime.tryParse((json['startDate'] as String?) ?? '') ??
          DateTime.now(),
    );
  }

  DoctorPatientOverviewPlan toEntity() {
    return DoctorPatientOverviewPlan(
      id: id,
      name: name,
      status: status,
      startDate: startDate,
    );
  }
}