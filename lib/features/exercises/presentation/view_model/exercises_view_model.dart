import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/di/session_scope.dart';
import '../../../../core/errors/unauthorized_exception.dart';
import '../../../auth/presentation/view_model/auth_view_model.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/exercise_filters.dart';
import '../state/exercises_state.dart';

class ExercisesViewModel extends AsyncNotifier<ExercisesState> {
  late final getExercises = ref.read(getExercisesUseCaseProvider);
  late final getExerciseById = ref.read(getExerciseByIdUseCaseProvider);
  late final createExercise = ref.read(createExerciseUseCaseProvider);
  late final updateExerciseUseCase = ref.read(updateExerciseUseCaseProvider);
  late final deleteExercise = ref.read(deleteExerciseUseCaseProvider);
  late final getFilterOptions = ref.read(getExerciseFilterOptionsUseCaseProvider);

  @override
  Future<ExercisesState> build() async {
    try {
      ref.watch(sessionEpochProvider);
      final filterOptions = await getFilterOptions();
      final list = await getExercises(pageNumber: 1, pageSize: 100, all: true);

      return ExercisesState(
        items: list,
        filterOptions: filterOptions,
      );
    } on UnauthorizedException {
      await ref.read(authViewModelProvider.notifier).logout();
      rethrow;
    }
  }

  Future<void> refresh() async {
    final previousFilters = state.valueOrNull?.filters ?? const ExerciseFilters();

    state = const AsyncLoading();

    final next = await AsyncValue.guard(() async {
      final filterOptions = await getFilterOptions();
      final list = await getExercises(pageNumber: 1, pageSize: 100, all: true);

      return ExercisesState(
        items: list,
        filterOptions: filterOptions,
        filters: previousFilters,
      );
    });

    if (next.hasError && next.error is UnauthorizedException) {
      await ref.read(authViewModelProvider.notifier).logout();
      return;
    }

    state = next;
  }

  Future<Exercise?> loadExerciseById(String id) async {
    try {
      return await getExerciseById(id);
    } on UnauthorizedException {
      await ref.read(authViewModelProvider.notifier).logout();
      return null;
    }
  }

  Future<void> removeExercise(String id) async {
    try {
      await deleteExercise(id);
      await refresh();
    } on UnauthorizedException {
      await ref.read(authViewModelProvider.notifier).logout();
    }
  }

  void applyFilters(ExerciseFilters filters) {
    final current = state.valueOrNull;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(filters: filters),
    );
  }
}

final exercisesViewModelProvider =
AsyncNotifierProvider<ExercisesViewModel, ExercisesState>(
  ExercisesViewModel.new,
);
