import '../../domain/entities/patient_program_plan.dart';

class PatientProgramPlanDto {
  final String id;
  final String name;
  final String status;
  final DateTime startDate;

  const PatientProgramPlanDto({
    required this.id,
    required this.name,
    required this.status,
    required this.startDate,
  });

  factory PatientProgramPlanDto.fromJson(Map<String, dynamic> json) {
    return PatientProgramPlanDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? '',
      startDate: DateTime.tryParse(json['startDate'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  PatientProgramPlan toEntity() {
    return PatientProgramPlan(
      id: id,
      name: name,
      status: status,
      startDate: startDate,
    );
  }
}