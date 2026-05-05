import '../../domain/entities/doctor_patient_overview.dart';
import 'doctor_patient_overview_day_dto.dart';
import 'doctor_patient_overview_patient_dto.dart';
import 'doctor_patient_overview_plan_dto.dart';
import 'doctor_patient_overview_progress_dto.dart';
import 'doctor_patient_overview_workout_dto.dart';

class DoctorPatientOverviewDto {
  final DoctorPatientOverviewPatientDto patient;
  final bool hasPlan;
  final DoctorPatientOverviewPlanDto? plan;
  final DoctorPatientOverviewProgressDto? progress;
  final List<DoctorPatientOverviewDayDto> days;
  final DoctorPatientOverviewWorkoutDto? todayWorkout;

  const DoctorPatientOverviewDto({
    required this.patient,
    required this.hasPlan,
    required this.plan,
    required this.progress,
    required this.days,
    required this.todayWorkout,
  });

  factory DoctorPatientOverviewDto.fromJson(Map<String, dynamic> json) {
    final patientRaw = json['patient'];
    final planRaw = json['plan'];
    final progressRaw = json['progress'];
    final daysRaw = (json['days'] as List?) ?? const [];
    final todayWorkoutRaw = json['todayWorkout'];

    return DoctorPatientOverviewDto(
      patient: DoctorPatientOverviewPatientDto.fromJson(
        patientRaw is Map<String, dynamic> ? patientRaw : const {},
      ),
      hasPlan: (json['hasPlan'] as bool?) ?? false,
      plan: planRaw is Map<String, dynamic>
          ? DoctorPatientOverviewPlanDto.fromJson(planRaw)
          : null,
      progress: progressRaw is Map<String, dynamic>
          ? DoctorPatientOverviewProgressDto.fromJson(progressRaw)
          : null,
      days: daysRaw
          .whereType<Map<String, dynamic>>()
          .map(DoctorPatientOverviewDayDto.fromJson)
          .toList(),
      todayWorkout: todayWorkoutRaw is Map<String, dynamic>
          ? DoctorPatientOverviewWorkoutDto.fromJson(todayWorkoutRaw)
          : null,
    );
  }

  DoctorPatientOverview toEntity() {
    return DoctorPatientOverview(
      patient: patient.toEntity(),
      hasPlan: hasPlan,
      plan: plan?.toEntity(),
      progress: progress?.toEntity(),
      days: days.map((x) => x.toEntity()).toList(),
      todayWorkout: todayWorkout?.toEntity(),
    );
  }
}