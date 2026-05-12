import '../../domain/entities/patient_selected_day_progress.dart';

class PatientSelectedDayProgressDto {
  final int wellBeingRating;
  final int workoutDifficultyRating;
  final bool hadPain;
  final int painIntensityRating;

  const PatientSelectedDayProgressDto({
    required this.wellBeingRating,
    required this.workoutDifficultyRating,
    required this.hadPain,
    required this.painIntensityRating,
  });

  factory PatientSelectedDayProgressDto.fromJson(Map<String, dynamic> json) {
    return PatientSelectedDayProgressDto(
      wellBeingRating: (json['wellBeingRating'] as num?)?.toInt() ?? 0,
      workoutDifficultyRating:
      (json['workoutDifficultyRating'] as num?)?.toInt() ?? 0,
      hadPain: json['hadPain'] as bool? ?? false,
      painIntensityRating: (json['painIntensityRating'] as num?)?.toInt() ?? 0,
    );
  }

  PatientSelectedDayProgress toEntity() {
    return PatientSelectedDayProgress(
      wellBeingRating: wellBeingRating,
      workoutDifficultyRating: workoutDifficultyRating,
      hadPain: hadPain,
      painIntensityRating: painIntensityRating,
    );
  }
}