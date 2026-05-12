import 'package:med_reability/features/patient/data/models/patient_workout_exercise_dto.dart';

import '../../domain/entities/patient_today_workout.dart';

class PatientTodayWorkoutDto {
  final DateTime date;
  final int dayNumber;
  final bool isCompletedToday;
  final bool isRestDay;
  final List<PatientWorkoutExerciseDto> exercises;

  const PatientTodayWorkoutDto({
    required this.date,
    required this.dayNumber,
    required this.isCompletedToday,
    required this.isRestDay,
    required this.exercises,
  });

  factory PatientTodayWorkoutDto.fromJson(Map<String, dynamic> json) {
    final exercisesRaw = json['exercises'] as List? ?? const [];

    return PatientTodayWorkoutDto(
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      dayNumber: (json['dayNumber'] as num?)?.toInt() ?? 0,
      isCompletedToday: json['isCompletedToday'] as bool? ?? false,
      isRestDay: json['isRestDay'] as bool? ?? false,
      exercises: exercisesRaw
          .whereType<Map<String, dynamic>>()
          .map(PatientWorkoutExerciseDto.fromJson)
          .toList(),
    );
  }

  PatientTodayWorkout toEntity() {
    return PatientTodayWorkout(
      date: date,
      dayNumber: dayNumber,
      isCompletedToday: isCompletedToday,
      isRestDay: isRestDay,
      exercises: exercises.map((x) => x.toEntity()).toList(),
    );
  }
}