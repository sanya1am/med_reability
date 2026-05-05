import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/core/di/providers.dart';
import 'package:med_reability/core/errors/unauthorized_exception.dart';
import 'package:med_reability/features/auth/presentation/view_model/auth_view_model.dart';

import '../../domain/entities/doctor_patient_overview.dart';
import '../../domain/entities/doctor_patient_overview_day.dart';
import '../state/doctor_patient_overview_state.dart';

class DoctorPatientOverviewViewModel extends FamilyAsyncNotifier<DoctorPatientOverviewState, String> {
  late final _getPatientOverview =
  ref.read(getDoctorPatientOverviewUseCaseProvider);

  late String _patientId;

  @override
  Future<DoctorPatientOverviewState> build(String patientId) async {
    _patientId = patientId;

    try {
      final overview = await _getPatientOverview(
        patientId: patientId,
      );

      final weekStartDate = _resolveInitialWeekStartDate(overview);
      final selectedDate = _resolveInitialSelectedDate(overview);

      return DoctorPatientOverviewState(
        patientId: patientId,
        overview: overview,
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
      );

      final weekStartDate = startDate ?? _resolveInitialWeekStartDate(overview);
      final selectedDate = _resolveSelectedDateAfterReload(
        overview: overview,
        previousSelectedDate: current?.selectedDate,
      );

      return DoctorPatientOverviewState(
        patientId: _patientId,
        overview: overview,
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
    final normalizedWeekStartDate = _dateOnly(weekStartDate);

    state = const AsyncLoading();

    final next = await AsyncValue.guard(() async {
      final overview = await _getPatientOverview(
        patientId: _patientId,
        startDate: normalizedWeekStartDate,
      );

      return DoctorPatientOverviewState(
        patientId: _patientId,
        overview: overview,
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

    await loadWeek(
      current.weekStartDate.subtract(const Duration(days: 7)),
    );
  }

  Future<void> nextWeek() async {
    final current = state.valueOrNull;
    if (current == null) return;

    await loadWeek(
      current.weekStartDate.add(const Duration(days: 7)),
    );
  }

  void selectDay(DoctorPatientOverviewDay day) {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(
        selectedDate: _dateOnly(day.date),
      ),
    );
  }

  DateTime _resolveInitialWeekStartDate(DoctorPatientOverview overview) {
    if (overview.days.isNotEmpty) {
      return _dateOnly(overview.days.first.date);
    }

    final planStartDate = overview.plan?.startDate;
    if (planStartDate != null) {
      return _dateOnly(planStartDate);
    }

    return _dateOnly(DateTime.now());
  }

  DateTime _resolveInitialSelectedDate(DoctorPatientOverview overview) {
    final today = _dateOnly(DateTime.now());

    for (final day in overview.days) {
      if (_isSameDate(day.date, today)) {
        return _dateOnly(day.date);
      }
    }

    for (final day in overview.days) {
      if (day.hasTraining) {
        return _dateOnly(day.date);
      }
    }

    if (overview.days.isNotEmpty) {
      return _dateOnly(overview.days.first.date);
    }

    return today;
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

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}

final doctorPatientOverviewViewModelProvider = AsyncNotifierProvider.family<
    DoctorPatientOverviewViewModel, DoctorPatientOverviewState, String
>(DoctorPatientOverviewViewModel.new);