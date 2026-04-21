import '../entities/exercise.dart';
import '../repositories/exercises_repository.dart';

class GetExercisesUseCase {
  final ExercisesRepository _repo;
  const GetExercisesUseCase(this._repo);

  Future<List<Exercise>> call({
    required int pageNumber,
    required int pageSize,
    required bool all,
  }) {
    return _repo.getExercises(pageNumber: pageNumber, pageSize: pageSize, all: all);
  }
}