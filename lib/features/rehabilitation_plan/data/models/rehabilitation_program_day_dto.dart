import '../../domain/entities/rehabilitation_program_day.dart';
import 'rehabilitation_program_exercise_dto.dart';

class RehabilitationProgramDayDto {
  final String? id;
  final int dayNumber;
  final bool isRestDay;
  final String? notes;
  final List<RehabilitationProgramExerciseDto> exercises;

  const RehabilitationProgramDayDto({
    required this.id,
    required this.dayNumber,
    required this.isRestDay,
    required this.notes,
    required this.exercises,
  });

  factory RehabilitationProgramDayDto.fromJson(Map<String, dynamic> json) {
    final exercisesRaw = (json['exercises'] as List?) ?? const [];

    return RehabilitationProgramDayDto(
      id: json['id'] as String?,
      dayNumber: (json['dayNumber'] as num?)?.toInt() ?? 0,
      isRestDay: (json['isRestDay'] as bool?) ?? false,
      notes: json['notes'] as String?,
      exercises: exercisesRaw
          .whereType<Map<String, dynamic>>()
          .map(RehabilitationProgramExerciseDto.fromJson)
          .toList(),
    );
  }

  RehabilitationProgramDay toEntity() {
    return RehabilitationProgramDay(
      id: id,
      dayNumber: dayNumber,
      isRestDay: isRestDay,
      notes: notes,
      exercises: exercises.map((x) => x.toEntity()).toList(),
    );
  }
}