import 'rehabilitation_program_exercise.dart';

class RehabilitationProgramDay {
  final String? id;
  final int dayNumber;
  final bool isRestDay;
  final String? notes;
  final List<RehabilitationProgramExercise> exercises;

  const RehabilitationProgramDay({
    required this.id,
    required this.dayNumber,
    required this.isRestDay,
    required this.notes,
    required this.exercises,
  });

  bool get hasExercises => exercises.isNotEmpty;

  bool get isFilled {
    return isRestDay ||
        exercises.isNotEmpty ||
        (notes != null && notes!.trim().isNotEmpty);
  }

  RehabilitationProgramDay copyWith({
    String? id,
    int? dayNumber,
    bool? isRestDay,
    String? notes,
    List<RehabilitationProgramExercise>? exercises,
  }) {
    return RehabilitationProgramDay(
      id: id ?? this.id,
      dayNumber: dayNumber ?? this.dayNumber,
      isRestDay: isRestDay ?? this.isRestDay,
      notes: notes ?? this.notes,
      exercises: exercises ?? this.exercises,
    );
  }
}