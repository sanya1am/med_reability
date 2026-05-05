import '../../domain/entities/exercise.dart';
import '../../domain/entities/exercise_filter_options.dart';
import '../../domain/entities/exercise_filters.dart';

class ExercisesState {
  final List<Exercise> items;
  final ExerciseFilterOptions filterOptions;
  final ExerciseFilters filters;

  const ExercisesState({
    required this.items,
    required this.filterOptions,
    this.filters = const ExerciseFilters(),
  });

  ExercisesState copyWith({
    List<Exercise>? items,
    ExerciseFilterOptions? filterOptions,
    ExerciseFilters? filters,
  }) {
    return ExercisesState(
      items: items ?? this.items,
      filterOptions: filterOptions ?? this.filterOptions,
      filters: filters ?? this.filters,
    );
  }
}