import '../../domain/entities/patient_program_progress.dart';

class PatientProgramProgressDto {
  final int completedDaysCount;
  final int plannedTrainingDaysCount;
  final int completionPercent;

  const PatientProgramProgressDto({
    required this.completedDaysCount,
    required this.plannedTrainingDaysCount,
    required this.completionPercent,
  });

  factory PatientProgramProgressDto.fromJson(Map<String, dynamic> json) {
    return PatientProgramProgressDto(
      completedDaysCount: (json['completedDaysCount'] as num?)?.toInt() ?? 0,
      plannedTrainingDaysCount:
      (json['plannedTrainingDaysCount'] as num?)?.toInt() ?? 0,
      completionPercent: (json['completionPercent'] as num?)?.toInt() ?? 0,
    );
  }

  PatientProgramProgress toEntity() {
    return PatientProgramProgress(
      completedDaysCount: completedDaysCount,
      plannedTrainingDaysCount: plannedTrainingDaysCount,
      completionPercent: completionPercent,
    );
  }
}