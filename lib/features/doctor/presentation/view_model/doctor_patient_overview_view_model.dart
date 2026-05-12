import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/core/di/providers.dart';
import 'package:med_reability/core/errors/unauthorized_exception.dart';
import 'package:med_reability/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:med_reability/features/rehabilitation_plan/domain/entities/rehabilitation_program.dart';

import '../../domain/entities/doctor_patient_overview.dart';
import '../../domain/entities/doctor_patient_overview_day.dart';
import '../state/doctor_patient_overview_state.dart';

class DoctorPatientOverviewViewModel extends FamilyAsyncNotifier<DoctorPatientOverviewState, String> {
  late final _getPatientOverview = ref.read(getDoctorPatientOverviewUseCaseProvider);
  late final _getProgram = ref.read(getRehabilitationProgramUseCaseProvider);
  late String _patientId;

  @override
  Future<DoctorPatientOverviewState> build(String patientId) async {
    _patientId = patientId;

    try {
      var overview = await _getPatientOverview(
        patientId: patientId,
      );

      final weekStartDate = _resolveInitialWeekStartDate(overview);

      if (overview.hasPlan && overview.plan != null) {
        overview = await _getPatientOverview(
          patientId: patientId,
          startDate: weekStartDate,
          workoutDate: weekStartDate,
        );
      }

      final program = await _loadProgramIfExists(overview);
      final selectedDate = _resolveInitialSelectedDate(overview);

      return DoctorPatientOverviewState(
        patientId: patientId,
        overview: overview,
        program: program,
        weekStartDate: weekStartDate,
        selectedDate: selectedDate,
      );
    } on UnauthorizedException {
      await ref.read(authViewModelProvider.notifier).logout();
      rethrow;
    }
  }

  Future<void> refresh() async {
    final current = state.valueOrNull;
    final startDate = current?.weekStartDate;

    state = const AsyncLoading();

    final next = await AsyncValue.guard(() async {
      final overview = await _getPatientOverview(
        patientId: _patientId,
        startDate: startDate,
        workoutDate: current?.selectedDate,
      );

      final program = await _loadProgramIfExists(overview);

      final weekStartDate = startDate ?? _resolveInitialWeekStartDate(overview);
      final selectedDate = _resolveSelectedDateAfterReload(
        overview: overview,
        previousSelectedDate: current?.selectedDate,
      );

      return DoctorPatientOverviewState(
        patientId: _patientId,
        overview: overview,
        program: program,
        weekStartDate: weekStartDate,
        selectedDate: selectedDate,
      );
    });

    if (next.hasError && next.error is UnauthorizedException) {
      await ref.read(authViewModelProvider.notifier).logout();
      return;
    }

    state = next;
  }

  Future<void> loadWeek(DateTime weekStartDate) async {
    final current = state.valueOrNull;
    final normalizedWeekStartDate = _dateOnly(weekStartDate);

    state = const AsyncLoading();

    final next = await AsyncValue.guard(() async {
      final overview = await _getPatientOverview(
        patientId: _patientId,
        startDate: normalizedWeekStartDate,
        workoutDate: normalizedWeekStartDate, // ??
      );

      final program = current?.program ?? await _loadProgramIfExists(overview);

      return DoctorPatientOverviewState(
        patientId: _patientId,
        overview: overview,
        program: program,
        weekStartDate: normalizedWeekStartDate,
        selectedDate: _resolveInitialSelectedDate(overview),
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
    if (!current.canGoPreviousWeek) return;

    await loadWeek(
      current.weekStartDate.subtract(const Duration(days: 7)),
    );
  }

  Future<void> nextWeek() async {
    final current = state.valueOrNull;
    if (current == null) return;
    if (!current.canGoNextWeek) return;

    await loadWeek(
      current.weekStartDate.add(const Duration(days: 7)),
    );
  }

  Future<void> selectDay(DoctorPatientOverviewDay day) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final selectedDate = _dateOnly(day.date);

    final optimisticState = current.copyWith(
      selectedDate: selectedDate,
    );

    state = AsyncData(optimisticState);

    final next = await AsyncValue.guard(() async {
      final overview = await _getPatientOverview(
        patientId: _patientId,
        startDate: current.weekStartDate,
        workoutDate: selectedDate,
      );

      return optimisticState.copyWith(
        overview: overview,
        program: current.program,
      );
    });

    if (next.hasError && next.error is UnauthorizedException) {
      await ref.read(authViewModelProvider.notifier).logout();
      return;
    }

    state = next;
  }

  DateTime _resolveInitialWeekStartDate(DoctorPatientOverview overview) {
    final planStartDate = overview.plan?.startDate;
    if (planStartDate != null) {
      return _dateOnly(planStartDate);
    }

    if (overview.days.isNotEmpty) {
      final sortedDays = [...overview.days]
        ..sort((a, b) => a.date.compareTo(b.date));

      return _dateOnly(sortedDays.first.date);
    }

    return _dateOnly(DateTime.now());
  }

  DateTime _resolveInitialSelectedDate(DoctorPatientOverview overview) {
    if (overview.days.isNotEmpty) {
      final sortedDays = [...overview.days]
        ..sort((a, b) => a.date.compareTo(b.date));

      return _dateOnly(sortedDays.first.date);
    }

    final planStartDate = overview.plan?.startDate;
    if (planStartDate != null) {
      return _dateOnly(planStartDate);
    }

    return _dateOnly(DateTime.now());
  }

  DateTime _resolveSelectedDateAfterReload({
    required DoctorPatientOverview overview,
    required DateTime? previousSelectedDate,
  }) {
    if (previousSelectedDate != null) {
      for (final day in overview.days) {
        if (_isSameDate(day.date, previousSelectedDate)) {
          return _dateOnly(day.date);
        }
      }
    }

    return _resolveInitialSelectedDate(overview);
  }

  Future<RehabilitationProgram?> _loadProgramIfExists(
      DoctorPatientOverview overview,
      ) async {
    final plan = overview.plan;

    if (!overview.hasPlan || plan == null || plan.id.isEmpty) {
      return null;
    }

    return _getProgram(id: plan.id);
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}

final doctorPatientOverviewViewModelProvider =
AsyncNotifierProvider.family<
    DoctorPatientOverviewViewModel,
    DoctorPatientOverviewState,
    String>(
  DoctorPatientOverviewViewModel.new,
);