import 'package:med_reability/features/rehabilitation_plan/domain/entities/rehabilitation_program.dart';
import 'package:med_reability/features/rehabilitation_plan/domain/entities/rehabilitation_program_day.dart';
import 'package:med_reability/features/rehabilitation_plan/domain/entities/rehabilitation_program_exercise.dart';

import '../../../exercises/domain/entities/exercise.dart';

enum RehabilitationProgramEditorMode {
  create,
  edit,
}

class RehabilitationProgramEditorState {
  final RehabilitationProgramEditorMode mode;
  final String patientId;
  final String? programId;

  final String name;
  final String description;
  final DateTime startDate;

  final List<RehabilitationProgramWeekDraft> weeks;

  final bool isSubmitting;
  final String? errorMessage;

  const RehabilitationProgramEditorState({
    required this.mode,
    required this.patientId,
    required this.programId,
    required this.name,
    required this.description,
    required this.startDate,
    required this.weeks,
    required this.isSubmitting,
    required this.errorMessage,
  });

  factory RehabilitationProgramEditorState.create({
    required String patientId,
  }) {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day);

    return RehabilitationProgramEditorState(
      mode: RehabilitationProgramEditorMode.create,
      patientId: patientId,
      programId: null,
      name: 'План реабилитации',
      description: '',
      startDate: startDate,
      weeks: [
        RehabilitationProgramWeekDraft.empty(
          weekNumber: 1,
          startDayNumber: 1,
        ),
      ],
      isSubmitting: false,
      errorMessage: null,
    );
  }

  factory RehabilitationProgramEditorState.fromProgram({
    required RehabilitationProgram program,
  }) {
    final sortedDays = [...program.days]
      ..sort((a, b) => a.dayNumber.compareTo(b.dayNumber));

    final weeks = <RehabilitationProgramWeekDraft>[];

    for (var i = 0; i < sortedDays.length; i += 7) {
      final chunk = sortedDays.skip(i).take(7).toList();
      final weekNumber = i ~/ 7 + 1;

      weeks.add(
        RehabilitationProgramWeekDraft.fromDays(
          weekNumber: weekNumber,
          days: chunk,
        ),
      );
    }

    return RehabilitationProgramEditorState(
      mode: RehabilitationProgramEditorMode.edit,
      patientId: program.patientId,
      programId: program.id,
      name: program.name,
      description: program.description,
      startDate: program.startDate,
      weeks: weeks.isEmpty
          ? [
        RehabilitationProgramWeekDraft.empty(
          weekNumber: 1,
          startDayNumber: 1,
        ),
      ]
          : weeks,
      isSubmitting: false,
      errorMessage: null,
    );
  }

  bool get isEdit => mode == RehabilitationProgramEditorMode.edit;

  bool get isCreate => mode == RehabilitationProgramEditorMode.create;

  List<RehabilitationProgramDayDraft> get allDays {
    return weeks.expand((week) => week.days).toList();
  }

  RehabilitationProgramEditorState copyWith({
    RehabilitationProgramEditorMode? mode,
    String? patientId,
    String? programId,
    String? name,
    String? description,
    DateTime? startDate,
    List<RehabilitationProgramWeekDraft>? weeks,
    bool? isSubmitting,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return RehabilitationProgramEditorState(
      mode: mode ?? this.mode,
      patientId: patientId ?? this.patientId,
      programId: programId ?? this.programId,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      weeks: weeks ?? this.weeks,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class RehabilitationProgramWeekDraft {
  final int weekNumber;
  final List<RehabilitationProgramDayDraft> days;

  const RehabilitationProgramWeekDraft({
    required this.weekNumber,
    required this.days,
  });

  factory RehabilitationProgramWeekDraft.empty({
    required int weekNumber,
    required int startDayNumber,
  }) {
    return RehabilitationProgramWeekDraft(
      weekNumber: weekNumber,
      days: List.generate(7, (index) {
        return RehabilitationProgramDayDraft.empty(
          dayNumber: startDayNumber + index,
        );
      }),
    );
  }

  factory RehabilitationProgramWeekDraft.fromDays({
    required int weekNumber,
    required List<RehabilitationProgramDay> days,
  }) {
    return RehabilitationProgramWeekDraft(
      weekNumber: weekNumber,
      days: days.map(RehabilitationProgramDayDraft.fromEntity).toList(),
    );
  }

  bool get isFilled {
    return days.any((day) => day.isFilled);
  }

  RehabilitationProgramWeekDraft copyWith({
    int? weekNumber,
    List<RehabilitationProgramDayDraft>? days,
  }) {
    return RehabilitationProgramWeekDraft(
      weekNumber: weekNumber ?? this.weekNumber,
      days: days ?? this.days,
    );
  }

  RehabilitationProgramWeekDraft deepCopy({
    int? weekNumber,
    int? startDayNumber,
  }) {
    final nextWeekNumber = weekNumber ?? this.weekNumber;
    final firstDayNumber = startDayNumber ?? days.firstOrNull?.dayNumber ?? 1;

    return RehabilitationProgramWeekDraft(
      weekNumber: nextWeekNumber,
      days: List.generate(days.length, (index) {
        return days[index].deepCopy(
          dayNumber: firstDayNumber + index,
        );
      }),
    );
  }
}

class RehabilitationProgramDayDraft {
  final String? id;
  final int dayNumber;
  final bool isRestDay;
  final String? notes;
  final List<RehabilitationProgramExerciseDraft> exercises;

  const RehabilitationProgramDayDraft({
    required this.id,
    required this.dayNumber,
    required this.isRestDay,
    required this.notes,
    required this.exercises,
  });

  factory RehabilitationProgramDayDraft.empty({
    required int dayNumber,
  }) {
    return RehabilitationProgramDayDraft(
      id: null,
      dayNumber: dayNumber,
      isRestDay: false,
      notes: null,
      exercises: const [],
    );
  }

  factory RehabilitationProgramDayDraft.fromEntity(
      RehabilitationProgramDay day,
      ) {
    return RehabilitationProgramDayDraft(
      id: day.id,
      dayNumber: day.dayNumber,
      isRestDay: day.isRestDay,
      notes: day.notes,
      exercises: day.exercises
          .map(RehabilitationProgramExerciseDraft.fromEntity)
          .toList(),
    );
  }

  bool get isFilled {
    return isRestDay ||
        exercises.isNotEmpty ||
        (notes != null && notes!.trim().isNotEmpty);
  }

  RehabilitationProgramDayDraft copyWith({
    String? id,
    int? dayNumber,
    bool? isRestDay,
    String? notes,
    List<RehabilitationProgramExerciseDraft>? exercises,
  }) {
    return RehabilitationProgramDayDraft(
      id: id ?? this.id,
      dayNumber: dayNumber ?? this.dayNumber,
      isRestDay: isRestDay ?? this.isRestDay,
      notes: notes ?? this.notes,
      exercises: exercises ?? this.exercises,
    );
  }

  RehabilitationProgramDayDraft deepCopy({
    int? dayNumber,
  }) {
    return RehabilitationProgramDayDraft(
      id: null,
      dayNumber: dayNumber ?? this.dayNumber,
      isRestDay: isRestDay,
      notes: notes,
      exercises: exercises
          .map((exercise) => exercise.deepCopy())
          .toList(growable: false),
    );
  }

  RehabilitationProgramDay toEntity() {
    return RehabilitationProgramDay(
      id: id,
      dayNumber: dayNumber,
      isRestDay: isRestDay,
      notes: notes,
      exercises: exercises
          .asMap()
          .entries
          .map((entry) {
        return entry.value.toEntity(order: entry.key + 1);
      })
          .toList(),
    );
  }
}

class RehabilitationProgramExerciseDraft {
  final String? id;
  final String exerciseId;
  final String exerciseName;
  final Exercise? exercise;

  final int sets;
  final int restBetweenSetsInSeconds;
  final int restAfterInSeconds;
  final int repetitions;
  final int durationSeconds;
  final String? comment;

  const RehabilitationProgramExerciseDraft({
    required this.id,
    required this.exerciseId,
    required this.exerciseName,
    required this.exercise,
    required this.sets,
    required this.restBetweenSetsInSeconds,
    required this.restAfterInSeconds,
    required this.repetitions,
    required this.durationSeconds,
    required this.comment,
  });

  factory RehabilitationProgramExerciseDraft.fromEntity(
      RehabilitationProgramExercise exercise,
      ) {
    return RehabilitationProgramExerciseDraft(
      id: exercise.id,
      exerciseId: exercise.exerciseId,
      exerciseName: exercise.exercise?.name ?? '',
      exercise: exercise.exercise,
      sets: exercise.sets,
      restBetweenSetsInSeconds: exercise.restBetweenSetsInSeconds,
      restAfterInSeconds: exercise.restAfterInSeconds,
      repetitions: exercise.repetitions,
      durationSeconds: exercise.durationSeconds,
      comment: exercise.comment,
    );
  }

  RehabilitationProgramExerciseDraft copyWith({
    String? id,
    String? exerciseId,
    String? exerciseName,
    Exercise? exercise,
    int? sets,
    int? restBetweenSetsInSeconds,
    int? restAfterInSeconds,
    int? repetitions,
    int? durationSeconds,
    String? comment,
  }) {
    return RehabilitationProgramExerciseDraft(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      exercise: exercise ?? this.exercise,
      sets: sets ?? this.sets,
      restBetweenSetsInSeconds:
      restBetweenSetsInSeconds ?? this.restBetweenSetsInSeconds,
      restAfterInSeconds: restAfterInSeconds ?? this.restAfterInSeconds,
      repetitions: repetitions ?? this.repetitions,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      comment: comment ?? this.comment,
    );
  }

  RehabilitationProgramExerciseDraft deepCopy() {
    return RehabilitationProgramExerciseDraft(
      id: null,
      exerciseId: exerciseId,
      exerciseName: exerciseName,
      exercise: exercise,
      sets: sets,
      restBetweenSetsInSeconds: restBetweenSetsInSeconds,
      restAfterInSeconds: restAfterInSeconds,
      repetitions: repetitions,
      durationSeconds: durationSeconds,
      comment: comment,
    );
  }

  RehabilitationProgramExercise toEntity({
    required int order,
  }) {
    return RehabilitationProgramExercise(
      id: id,
      order: order,
      exerciseId: exerciseId,
      exercise: exercise,
      sets: sets,
      restBetweenSetsInSeconds: restBetweenSetsInSeconds,
      restAfterInSeconds: restAfterInSeconds,
      repetitions: repetitions,
      durationSeconds: durationSeconds,
      comment: comment,
    );
  }
}