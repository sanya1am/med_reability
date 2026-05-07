import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/core/di/providers.dart';
import 'package:med_reability/core/errors/unauthorized_exception.dart';
import 'package:med_reability/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:med_reability/features/rehabilitation_plan/domain/entities/rehabilitation_program.dart';
import 'package:med_reability/features/rehabilitation_plan/domain/entities/rehabilitation_program_day.dart';
import 'package:med_reability/features/rehabilitation_plan/domain/entities/rehabilitation_program_exercise.dart';
import 'package:med_reability/features/rehabilitation_plan/domain/entities/rehabilitation_program_template.dart';
import '../state/rehabilitation_program_editor_state.dart';

class RehabilitationProgramEditorArgs {
  final String patientId;
  final RehabilitationProgram? initialProgram;

  const RehabilitationProgramEditorArgs({
    required this.patientId,
    this.initialProgram,
  });

  String? get programId => initialProgram?.id;

  String get scopeId {
    final id = programId;
    if (id != null && id.isNotEmpty) {
      return 'program:$id';
    }
    return 'patient:$patientId:create';
  }

  @override
  bool operator ==(Object other) {
    return other is RehabilitationProgramEditorArgs &&
        other.patientId == patientId &&
        other.programId == programId;
  }

  @override
  int get hashCode {
    return Object.hash(patientId, programId);
  }
}


class RehabilitationProgramEditorViewModel
    extends FamilyNotifier<RehabilitationProgramEditorState,
        RehabilitationProgramEditorArgs> {
  late final _createProgram = ref.read(createRehabilitationProgramUseCaseProvider);
  late final _updateProgram = ref.read(updateRehabilitationProgramUseCaseProvider);
  late final _deleteProgram = ref.read(deleteRehabilitationProgramUseCaseProvider);

  @override
  RehabilitationProgramEditorState build(
      RehabilitationProgramEditorArgs arg,
      ) {
    final initialProgram = arg.initialProgram;

    if (initialProgram != null) {
      return RehabilitationProgramEditorState.fromProgram(
        program: initialProgram,
      );
    }

    return RehabilitationProgramEditorState.create(
      patientId: arg.patientId,
    );
  }

  bool get isProgramEmpty {
    return state.allDays.every((day) => day.exercises.isEmpty);
  }

  void setName(String value) {
    state = state.copyWith(
      name: value,
      clearErrorMessage: true,
    );
  }

  void setDescription(String value) {
    state = state.copyWith(
      description: value,
      clearErrorMessage: true,
    );
  }

  void setStartDate(DateTime value) {
    state = state.copyWith(
      startDate: DateTime(value.year, value.month, value.day),
      clearErrorMessage: true,
    );
  }

  void addWeek() {
    final nextWeekNumber = state.weeks.length + 1;
    final startDayNumber = (nextWeekNumber - 1) * 7 + 1;

    final nextWeeks = [
      ...state.weeks,
      RehabilitationProgramWeekDraft.empty(
        weekNumber: nextWeekNumber,
        startDayNumber: startDayNumber,
      ),
    ];

    state = state.copyWith(
      weeks: _renumberWeeks(nextWeeks),
      clearErrorMessage: true,
    );
  }

  void deleteWeek(int weekIndex) {
    if (weekIndex < 0 || weekIndex >= state.weeks.length) return;

    final nextWeeks = [...state.weeks]..removeAt(weekIndex);

    state = state.copyWith(
      weeks: _renumberWeeks(nextWeeks),
      clearErrorMessage: true,
    );
  }

  void clearWeek(int weekIndex) {
    if (weekIndex < 0 || weekIndex >= state.weeks.length) return;

    final week = state.weeks[weekIndex];
    final startDayNumber = (week.weekNumber - 1) * 7 + 1;

    final nextWeeks = [...state.weeks];
    nextWeeks[weekIndex] = RehabilitationProgramWeekDraft.empty(
      weekNumber: week.weekNumber,
      startDayNumber: startDayNumber,
    );

    state = state.copyWith(
      weeks: nextWeeks,
      clearErrorMessage: true,
    );
  }

  void clearDay({
    required int weekIndex,
    required int dayIndex,
  }) {
    if (weekIndex < 0 || weekIndex >= state.weeks.length) return;

    final week = state.weeks[weekIndex];
    if (dayIndex < 0 || dayIndex >= week.days.length) return;

    final targetDay = week.days[dayIndex];

    final nextDays = [...week.days];
    nextDays[dayIndex] = RehabilitationProgramDayDraft.empty(
      dayNumber: targetDay.dayNumber,
    );

    _replaceWeekDays(
      weekIndex: weekIndex,
      days: nextDays,
    );
  }

  void setDayRest({
    required int weekIndex,
    required int dayIndex,
    required bool isRestDay,
  }) {
    final day = _getDay(weekIndex: weekIndex, dayIndex: dayIndex);
    if (day == null) return;

    final nextDay = day.copyWith(
      isRestDay: isRestDay,
    );

    _replaceDay(
      weekIndex: weekIndex,
      dayIndex: dayIndex,
      day: nextDay,
    );
  }

  void setDayNotes({
    required int weekIndex,
    required int dayIndex,
    required String notes,
  }) {
    final day = _getDay(weekIndex: weekIndex, dayIndex: dayIndex);
    if (day == null) return;

    final nextDay = day.copyWith(
      notes: notes,
    );

    _replaceDay(
      weekIndex: weekIndex,
      dayIndex: dayIndex,
      day: nextDay,
    );
  }

  Future<bool> submit() async {
    final name = state.name.trim();
    final description = state.description.trim();

    if (name.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Введите название плана',
      );
      return false;
    }

    final validationError = _validateBeforeSubmit();

    if (validationError != null) {
      state = state.copyWith(
        errorMessage: validationError,
      );
      return false;
    }

    final days = state.allDays.map((day) => day.toEntity()).toList();

    state = state.copyWith(
      isSubmitting: true,
      clearErrorMessage: true,
    );

    final result = await AsyncValue.guard(() async {
      if (state.isEdit) {
        final programId = state.programId;
        if (programId == null || programId.isEmpty) {
          throw Exception('Не найден идентификатор плана');
        }

        return _updateProgram(
          id: programId,
          name: name,
          description: description,
          startDate: state.startDate,
          days: days,
        );
      }

      return _createProgram(
        patientId: state.patientId,
        name: name,
        description: description,
        startDate: state.startDate,
        days: days,
      );
    });

    if (result.hasError) {
      final error = result.error;

      if (error is UnauthorizedException) {
        await ref.read(authViewModelProvider.notifier).logout();
        return false;
      }

      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.toString(),
      );
      return false;
    }

    state = state.copyWith(
      isSubmitting: false,
      clearErrorMessage: true,
    );

    return true;
  }

  Future<bool> deleteProgram() async {
    final programId = state.programId;

    if (programId == null || programId.isEmpty) {
      state = state.copyWith(
        errorMessage: 'Не найден идентификатор плана',
      );
      return false;
    }

    state = state.copyWith(
      isSubmitting: true,
      clearErrorMessage: true,
    );

    final result = await AsyncValue.guard(() async {
      await _deleteProgram(id: programId);
    });

    if (result.hasError) {
      final error = result.error;

      if (error is UnauthorizedException) {
        await ref.read(authViewModelProvider.notifier).logout();
        return false;
      }

      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.toString(),
      );
      return false;
    }

    state = state.copyWith(
      isSubmitting: false,
      clearErrorMessage: true,
    );

    return true;
  }

  void applyWeekTemplate({
    required int targetWeekIndex,
    required RehabilitationProgramWeekTemplate template,
  }) {
    if (targetWeekIndex < 0 || targetWeekIndex >= state.weeks.length) return;

    final targetWeek = state.weeks[targetWeekIndex];
    final startDayNumber = (targetWeek.weekNumber - 1) * 7 + 1;

    final nextDays = List.generate(targetWeek.days.length, (index) {
      final targetDayNumber = startDayNumber + index;

      if (index >= template.days.length) {
        return RehabilitationProgramDayDraft.empty(
          dayNumber: targetDayNumber,
        );
      }

      return _dayDraftFromTemplate(
        template.days[index],
        dayNumber: targetDayNumber,
      );
    });

    final nextWeeks = [...state.weeks];
    nextWeeks[targetWeekIndex] = targetWeek.copyWith(
      days: nextDays,
    );

    state = state.copyWith(
      weeks: nextWeeks,
      clearErrorMessage: true,
    );
  }

  void applyDayTemplate({
    required int weekIndex,
    required int dayIndex,
    required RehabilitationProgramDayTemplate template,
  }) {
    if (weekIndex < 0 || weekIndex >= state.weeks.length) return;

    final week = state.weeks[weekIndex];

    if (dayIndex < 0 || dayIndex >= week.days.length) return;

    final targetDay = week.days[dayIndex];

    final copiedDay = _dayDraftFromTemplate(
      template.day,
      dayNumber: targetDay.dayNumber,
    );

    final nextDays = [...week.days];
    nextDays[dayIndex] = copiedDay;

    _replaceWeekDays(
      weekIndex: weekIndex,
      days: nextDays,
    );
  }

  void addExerciseToDay({
    required int weekIndex,
    required int dayIndex,
    required RehabilitationProgramExerciseDraft exercise,
  }) {
    final day = _getDay(
      weekIndex: weekIndex,
      dayIndex: dayIndex,
    );

    if (day == null) return;

    final nextExercises = [
      ...day.exercises,
      exercise,
    ];

    final nextDay = day.copyWith(
      isRestDay: false,
      exercises: nextExercises,
    );

    _replaceDay(
      weekIndex: weekIndex,
      dayIndex: dayIndex,
      day: nextDay,
    );
  }

  void updateExerciseInDay({
    required int weekIndex,
    required int dayIndex,
    required int exerciseIndex,
    required RehabilitationProgramExerciseDraft exercise,
  }) {
    final day = _getDay(
      weekIndex: weekIndex,
      dayIndex: dayIndex,
    );

    if (day == null) return;
    if (exerciseIndex < 0 || exerciseIndex >= day.exercises.length) return;

    final nextExercises = [...day.exercises];
    nextExercises[exerciseIndex] = exercise;

    final nextDay = day.copyWith(
      exercises: nextExercises,
    );

    _replaceDay(
      weekIndex: weekIndex,
      dayIndex: dayIndex,
      day: nextDay,
    );
  }

  void removeExerciseFromDay({
    required int weekIndex,
    required int dayIndex,
    required int exerciseIndex,
  }) {
    final day = _getDay(
      weekIndex: weekIndex,
      dayIndex: dayIndex,
    );

    if (day == null) return;
    if (exerciseIndex < 0 || exerciseIndex >= day.exercises.length) return;

    final nextExercises = [...day.exercises]..removeAt(exerciseIndex);

    final nextDay = day.copyWith(
      exercises: nextExercises,
    );

    _replaceDay(
      weekIndex: weekIndex,
      dayIndex: dayIndex,
      day: nextDay,
    );
  }


  List<RehabilitationProgramWeekDraft> _renumberWeeks(
      List<RehabilitationProgramWeekDraft> weeks,
      ) {
    return List.generate(weeks.length, (weekIndex) {
      final weekNumber = weekIndex + 1;
      final startDayNumber = weekIndex * 7 + 1;

      return weeks[weekIndex].deepCopy(
        weekNumber: weekNumber,
        startDayNumber: startDayNumber,
      );
    });
  }

  RehabilitationProgramDayDraft? _getDay({
    required int weekIndex,
    required int dayIndex,
  }) {
    if (weekIndex < 0 || weekIndex >= state.weeks.length) return null;

    final week = state.weeks[weekIndex];

    if (dayIndex < 0 || dayIndex >= week.days.length) return null;

    return week.days[dayIndex];
  }

  void _replaceDay({
    required int weekIndex,
    required int dayIndex,
    required RehabilitationProgramDayDraft day,
  }) {
    if (weekIndex < 0 || weekIndex >= state.weeks.length) return;

    final week = state.weeks[weekIndex];
    if (dayIndex < 0 || dayIndex >= week.days.length) return;

    final nextDays = [...week.days];
    nextDays[dayIndex] = day;

    _replaceWeekDays(
      weekIndex: weekIndex,
      days: nextDays,
    );
  }

  void _replaceWeekDays({
    required int weekIndex,
    required List<RehabilitationProgramDayDraft> days,
  }) {
    if (weekIndex < 0 || weekIndex >= state.weeks.length) return;

    final nextWeeks = [...state.weeks];
    nextWeeks[weekIndex] = nextWeeks[weekIndex].copyWith(
      days: days,
    );

    state = state.copyWith(
      weeks: nextWeeks,
      clearErrorMessage: true,
    );
  }

  RehabilitationProgramDayDraft _dayDraftFromTemplate(
      RehabilitationProgramDay day, {
        required int dayNumber,
      }) {
    return RehabilitationProgramDayDraft(
      id: null,
      dayNumber: dayNumber,
      isRestDay: day.isRestDay,
      notes: day.notes,
      exercises: day.exercises
          .map(_exerciseDraftFromTemplate)
          .toList(growable: false),
    );
  }

  RehabilitationProgramExerciseDraft _exerciseDraftFromTemplate(
      RehabilitationProgramExercise exercise,
      ) {
    return RehabilitationProgramExerciseDraft(
      id: null,
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

  String? _validateBeforeSubmit() {
    final daysWithExercises = state.allDays
        .where((day) => day.exercises.isNotEmpty)
        .toList();

    if (daysWithExercises.isEmpty) {
      return 'Добавьте хотя бы один день с упражнениями';
    }

    for (final day in daysWithExercises) {
      for (final exercise in day.exercises) {
        final hasRepetitions = exercise.repetitions > 0;
        final hasDuration = exercise.durationSeconds > 0;

        if (hasRepetitions == hasDuration) {
          final exerciseName = exercise.exerciseName.isEmpty
              ? 'Упражнение'
              : exercise.exerciseName;

          return 'В дне ${day.dayNumber} для упражнения "$exerciseName" укажите либо повторения, либо время выполнения';
        }

        if (exercise.sets <= 0) {
          final exerciseName = exercise.exerciseName.isEmpty
              ? 'Упражнение'
              : exercise.exerciseName;

          return 'В дне ${day.dayNumber} для упражнения "$exerciseName" укажите количество подходов';
        }
      }
    }

    return null;
  }
}

final rehabilitationProgramEditorViewModelProvider =
NotifierProvider.family<
    RehabilitationProgramEditorViewModel,
    RehabilitationProgramEditorState,
    RehabilitationProgramEditorArgs>(
  RehabilitationProgramEditorViewModel.new,
);