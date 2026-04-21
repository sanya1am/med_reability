import '../entities/exercise.dart';
import '../entities/exercise_media_file.dart';
import '../entities/exercise_type.dart';
import '../repositories/exercises_repository.dart';

class UpdateExerciseUseCase {
  final ExercisesRepository _repo;
  const UpdateExerciseUseCase(this._repo);

  Future<Exercise> call({
    required String id,
    required String name,
    required String description,
    required List<String> steps,
    required ExerciseType type,
    List<ExerciseMediaFile> mediaFiles = const [],
  }) {
    return _repo.updateExercise(
      id: id,
      name: name,
      description: description,
      steps: steps,
      type: type,
      mediaFiles: mediaFiles,
    );
  }
}