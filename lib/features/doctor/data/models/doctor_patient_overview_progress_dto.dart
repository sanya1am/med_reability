import '../../domain/entities/doctor_patient_overview_progress.dart';

class DoctorPatientOverviewProgressDto {
  final int completedDaysCount;
  final int plannedTrainingDaysCount;
  final int completionPercent;

  const DoctorPatientOverviewProgressDto({
    required this.completedDaysCount,
    required this.plannedTrainingDaysCount,
    required this.completionPercent,
  });

  factory DoctorPatientOverviewProgressDto.fromJson(Map<String, dynamic> json) {
    return DoctorPatientOverviewProgressDto(
      completedDaysCount: (json['completedDaysCount'] as num?)?.toInt() ?? 0,
      plannedTrainingDaysCount:
      (json['plannedTrainingDaysCount'] as num?)?.toInt() ?? 0,
      completionPercent: (json['completionPercent'] as num?)?.toInt() ?? 0,
    );
  }

  DoctorPatientOverviewProgress toEntity() {
    return DoctorPatientOverviewProgress(
      completedDaysCount: completedDaysCount,
      plannedTrainingDaysCount: plannedTrainingDaysCount,
      completionPercent: completionPercent,
    );
  }
}