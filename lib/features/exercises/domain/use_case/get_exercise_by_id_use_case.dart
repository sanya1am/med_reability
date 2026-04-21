import '../entities/exercise.dart';
import '../repositories/exercises_repository.dart';

class GetExerciseByIdUseCase {
  final ExercisesRepository _repo;
  const GetExerciseByIdUseCase(this._repo);

  Future<Exercise> call(String id) {
    return _repo.getExerciseById(id);
  }
}