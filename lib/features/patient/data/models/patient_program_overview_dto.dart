import 'package:med_reability/features/exercises/data/models/exercise_dto.dart';
import 'package:med_reability/features/patient/data/models/patient_program_day_dto.dart';
import 'package:med_reability/features/patient/data/models/patient_program_plan_dto.dart';
import 'package:med_reability/features/patient/data/models/patient_program_progress_dto.dart';
import 'package:med_reability/features/patient/data/models/patient_selected_day_progress_dto.dart';
import 'package:med_reability/features/patient/data/models/patient_today_workout_dto.dart';
import '../../domain/entities/patient_program_overview.dart';

class PatientProgramOverviewDto {
  final bool hasPlan;
  final PatientProgramPlanDto? plan;
  final PatientProgramProgressDto? progress;
  final List<PatientProgramDayDto> days;
  final PatientTodayWorkoutDto? todayWorkout;
  final PatientSelectedDayProgressDto? selectedDayProgress;

  const PatientProgramOverviewDto({
    required this.hasPlan,
    required this.plan,
    required this.progress,
    required this.days,
    required this.todayWorkout,
    required this.selectedDayProgress,
  });

  factory PatientProgramOverviewDto.fromJson(Map<String, dynamic> json) {
    final daysRaw = json['days'] as List? ?? const [];

    return PatientProgramOverviewDto(
      hasPlan: json['hasPlan'] as bool? ?? false,
      plan: json['plan'] is Map<String, dynamic>
          ? PatientProgramPlanDto.fromJson(json['plan'] as Map<String, dynamic>)
          : null,
      progress: json['progress'] is Map<String, dynamic>
          ? PatientProgramProgressDto.fromJson(
        json['progress'] as Map<String, dynamic>,
      )
          : null,
      days: daysRaw
          .whereType<Map<String, dynamic>>()
          .map(PatientProgramDayDto.fromJson)
          .toList(),
      todayWorkout: json['todayWorkout'] is Map<String, dynamic>
          ? PatientTodayWorkoutDto.fromJson(
        json['todayWorkout'] as Map<String, dynamic>,
      )
          : null,
      selectedDayProgress: json['selectedDayProgress'] is Map<String, dynamic>
          ? PatientSelectedDayProgressDto.fromJson(
        json['selectedDayProgress'] as Map<String, dynamic>,
      )
          : null,
    );
  }

  PatientProgramOverview toEntity() {
    return PatientProgramOverview(
      hasPlan: hasPlan,
      plan: plan?.toEntity(),
      progress: progress?.toEntity(),
      days: days.map((x) => x.toEntity()).toList(),
      todayWorkout: todayWorkout?.toEntity(),
      selectedDayProgress: selectedDayProgress?.toEntity(),
    );
  }
}

