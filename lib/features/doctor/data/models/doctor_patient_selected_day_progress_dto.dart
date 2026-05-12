import 'package:med_reability/features/doctor/domain/entities/doctor_patient_selected_day_progress.dart';

class DoctorPatientSelectedDayProgressDto {
  final int wellBeingRating;
  final int workoutDifficultyRating;
  final bool hadPain;
  final int painIntensityRating;

  const DoctorPatientSelectedDayProgressDto({
    required this.wellBeingRating,
    required this.workoutDifficultyRating,
    required this.hadPain,
    required this.painIntensityRating,
  });

  factory DoctorPatientSelectedDayProgressDto.fromJson(Map<String, dynamic> json) {
    return DoctorPatientSelectedDayProgressDto(
      wellBeingRating: (json['wellBeingRating'] as num?)?.toInt() ?? 0,
      workoutDifficultyRating:
      (json['workoutDifficultyRating'] as num?)?.toInt() ?? 0,
      hadPain: json['hadPain'] as bool? ?? false,
      painIntensityRating:
      (json['painIntensityRating'] as num?)?.toInt() ?? 0,
    );
  }

  DoctorPatientSelectedDayProgress toEntity() {
    return DoctorPatientSelectedDayProgress(
      wellBeingRating: wellBeingRating,
      workoutDifficultyRating: workoutDifficultyRating,
      hadPain: hadPain,
      painIntensityRating: painIntensityRating,
    );
  }
}