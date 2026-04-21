import '../repositories/exercises_repository.dart';

class DeleteExerciseUseCase {
  final ExercisesRepository _repo;
  const DeleteExerciseUseCase(this._repo);

  Future<void> call(String id) => _repo.deleteExercise(id);
}