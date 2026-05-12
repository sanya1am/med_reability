import '../../domain/entities/patient_program_day.dart';

class PatientProgramDayDto {
  final DateTime date;
  final int dayNumber;
  final String dayType;
  final bool hasTraining;
  final bool isCompleted;
  final int wellBeingRating;
  final int workoutDifficultyRating;
  final bool hadPain;
  final int painIntensityRating;

  const PatientProgramDayDto({
    required this.date,
    required this.dayNumber,
    required this.dayType,
    required this.hasTraining,
    required this.isCompleted,
    required this.wellBeingRating,
    required this.workoutDifficultyRating,
    required this.hadPain,
    required this.painIntensityRating,
  });

  factory PatientProgramDayDto.fromJson(Map<String, dynamic> json) {
    return PatientProgramDayDto(
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      dayNumber: (json['dayNumber'] as num?)?.toInt() ?? 0,
      dayType: json['dayType'] as String? ?? '',
      hasTraining: json['hasTraining'] as bool? ?? false,
      isCompleted: json['isCompleted'] as bool? ?? false,
      wellBeingRating: (json['wellBeingRating'] as num?)?.toInt() ?? 0,
      workoutDifficultyRating:
      (json['workoutDifficultyRating'] as num?)?.toInt() ?? 0,
      hadPain: json['hadPain'] as bool? ?? false,
      painIntensityRating: (json['painIntensityRating'] as num?)?.toInt() ?? 0,
    );
  }

  PatientProgramDay toEntity() {
    return PatientProgramDay(
      date: date,
      dayNumber: dayNumber,
      dayType: dayType,
      hasTraining: hasTraining,
      isCompleted: isCompleted,
      wellBeingRating: wellBeingRating,
      workoutDifficultyRating: workoutDifficultyRating,
      hadPain: hadPain,
      painIntensityRating: painIntensityRating,
    );
  }
}