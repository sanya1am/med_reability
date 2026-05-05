import '../entities/exercise_filter_options.dart';
import '../repositories/exercises_repository.dart';

class GetExerciseFilterOptionsUseCase {
  final ExercisesRepository _repo;

  const GetExerciseFilterOptionsUseCase(this._repo);

  Future<ExerciseFilterOptions> call() {
    return _repo.getFilterOptions();
  }
}