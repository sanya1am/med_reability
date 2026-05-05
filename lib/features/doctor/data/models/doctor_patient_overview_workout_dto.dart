import '../../domain/entities/doctor_patient_overview_workout.dart';
import 'doctor_patient_overview_workout_exercise_dto.dart';

class DoctorPatientOverviewWorkoutDto {
  final DateTime date;
  final int dayNumber;
  final bool isCompletedToday;
  final bool isRestDay;
  final List<DoctorPatientOverviewWorkoutExerciseDto> exercises;

  const DoctorPatientOverviewWorkoutDto({
    required this.date,
    required this.dayNumber,
    required this.isCompletedToday,
    required this.isRestDay,
    required this.exercises,
  });

  factory DoctorPatientOverviewWorkoutDto.fromJson(Map<String, dynamic> json) {
    final exercisesRaw = (json['exercises'] as List?) ?? const [];

    return DoctorPatientOverviewWorkoutDto(
      date: DateTime.tryParse((json['date'] as String?) ?? '') ??
          DateTime.now(),
      dayNumber: (json['dayNumber'] as num?)?.toInt() ?? 0,
      isCompletedToday: (json['isCompletedToday'] as bool?) ?? false,
      isRestDay: (json['isRestDay'] as bool?) ?? false,
      exercises: exercisesRaw
          .whereType<Map<String, dynamic>>()
          .map(DoctorPatientOverviewWorkoutExerciseDto.fromJson)
          .toList(),
    );
  }

  DoctorPatientOverviewWorkout toEntity() {
    return DoctorPatientOverviewWorkout(
      date: date,
      dayNumber: dayNumber,
      isCompletedToday: isCompletedToday,
      isRestDay: isRestDay,
      exercises: exercises.map((x) => x.toEntity()).toList(),
    );
  }
}