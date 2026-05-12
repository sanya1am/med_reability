import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/core/di/providers.dart';
import 'package:med_reability/core/errors/unauthorized_exception.dart';
import 'package:med_reability/core/di/session_scope.dart';
import 'package:med_reability/features/auth/presentation/view_model/auth_view_model.dart';
import '../state/patient_program_overview_state.dart';

class PatientProgramOverviewViewModel
    extends AsyncNotifier<PatientProgramOverviewState> {
  late final _getOverview = ref.read(getPatientProgramOverviewUseCaseProvider);
  late final _completeExercise = ref.read(completePatientExerciseUseCaseProvider);
  late final _completeDay = ref.read(completePatientTrainingDayUseCaseProvider);
  late final _updateDayProgress = ref.read(updatePatientDayProgressUseCaseProvider);

  @override
  Future<PatientProgramOverviewState> build() async {
    ref.watch(sessionEpochProvider);

    try {
      final now = _dateOnly(DateTime.now());
      final weekStartDate = _startOfWeek(now);

      final overview = await _getOverview(
        startDate: weekStartDate,
        workoutDate: now,
      );

      return PatientProgramOverviewState(
        overview: overview,
        weekStartDate: weekStartDate,
        selectedDate: now,
      );
    } on UnauthorizedException {
      await ref.read(authViewModelProvider.notifier).logout();
      rethrow;
    }
  }

  Future<void> refresh() async {
    final current = state.valueOrNull;
    if (current == null) return;

    state = const AsyncLoading();

    final next = await AsyncValue.guard(() async {
      final overview = await _getOverview(
        startDate: current.weekStartDate,
        workoutDate: current.selectedDate,
      );

      return current.copyWith(
        overview: overview,
      );
    });

    if (next.hasError && next.error is UnauthorizedException) {
      await ref.read(authViewModelProvider.notifier).logout();
      return;
    }

    state = next;
  }

  Future<bool> completeExercise({
    required String dayExerciseId,
  }) async {
    final current = state.valueOrNull;
    if (current == null) return false;

    final planId = current.planId;
    final dayNumber = current.currentDayNumber;

    if (planId == null || planId.isEmpty || dayNumber == null) {
      return false;
    }

    final result = await AsyncValue.guard(() {
      return _completeExercise(
        planId: planId,
        dayNumber: dayNumber,
        dayExerciseId: dayExerciseId,
      );
    });

    if (result.hasError) {
      if (result.error is UnauthorizedException) {
        await ref.read(authViewModelProvider.notifier).logout();
      }

      return false;
    }

    return true;
  }

  Future<bool> completeSelectedDay() async {
    final current = state.valueOrNull;
    if (current == null) return false;

    final planId = current.planId;
    final dayNumber = current.currentDayNumber;

    if (planId == null || planId.isEmpty || dayNumber == null) {
      return false;
    }

    final result = await AsyncValue.guard(() {
      return _completeDay(
        planId: planId,
        dayNumber: dayNumber,
      );
    });

    if (result.hasError) {
      if (result.error is UnauthorizedException) {
        await ref.read(authViewModelProvider.notifier).logout();
      }

      return false;
    }

    await refresh();
    return true;
  }

  Future<bool> updateSelectedDayProgress({
    required int wellBeingRating,
    required int workoutDifficultyRating,
    required bool hadPain,
    required int painIntensityRating,
  }) async {
    final current = state.valueOrNull;
    if (current == null) return false;

    final planId = current.planId;
    final dayNumber = current.currentDayNumber;

    if (planId == null || planId.isEmpty || dayNumber == null) {
      return false;
    }

    final result = await AsyncValue.guard(() {
      return _updateDayProgress(
        planId: planId,
        dayNumber: dayNumber,
        wellBeingRating: wellBeingRating,
        workoutDifficultyRating: workoutDifficultyRating,
        hadPain: hadPain,
        painIntensityRating: painIntensityRating,
      );
    });

    if (result.hasError) {
      if (result.error is UnauthorizedException) {
        await ref.read(authViewModelProvider.notifier).logout();
      }

      return false;
    }

    await refresh();
    return true;
  }

  Future<void> selectDay(DateTime date) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final selectedDate = _dateOnly(date);

    state = const AsyncLoading();

    final next = await AsyncValue.guard(() async {
      final overview = await _getOverview(
        startDate: current.weekStartDate,
        workoutDate: selectedDate,
      );

      return current.copyWith(
        overview: overview,
        selectedDate: selectedDate,
      );
    });

    if (next.hasError && next.error is UnauthorizedException) {
      await ref.read(authViewModelProvider.notifier).logout();
      return;
    }

    state = next;
  }

  Future<void> previousWeek() async {
    final current = state.valueOrNull;
    if (current == null) return;

    await _loadWeek(
      current.weekStartDate.subtract(const Duration(days: 7)),
    );
  }

  Future<void> nextWeek() async {
    final current = state.valueOrNull;
    if (current == null) return;

    await _loadWeek(
      current.weekStartDate.add(const Duration(days: 7)),
    );
  }

  Future<void> _loadWeek(DateTime weekStartDate) async {
    final normalized = _dateOnly(weekStartDate);

    state = const AsyncLoading();

    final next = await AsyncValue.guard(() async {
      final overview = await _getOverview(
        startDate: normalized,
        workoutDate: normalized,
      );

      return PatientProgramOverviewState(
        overview: overview,
        weekStartDate: normalized,
        selectedDate: normalized,
      );
    });

    if (next.hasError && next.error is UnauthorizedException) {
      await ref.read(authViewModelProvider.notifier).logout();
      return;
    }

    state = next;
  }

  DateTime _startOfWeek(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day - date.weekday + 1,
    );
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}

final patientProgramOverviewViewModelProvider =
AsyncNotifierProvider<PatientProgramOverviewViewModel,
    PatientProgramOverviewState>(
  PatientProgramOverviewViewModel.new,
);