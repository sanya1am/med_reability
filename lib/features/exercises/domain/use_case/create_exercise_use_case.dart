import '../entities/exercise.dart';
import '../entities/exercise_media_file.dart';
import '../entities/exercise_type.dart';
import '../repositories/exercises_repository.dart';

class CreateExerciseUseCase {
  final ExercisesRepository _repo;
  const CreateExerciseUseCase(this._repo);

  Future<Exercise> call({
    required String name,
    required String description,
    required List<String> steps,
    required ExerciseType type,
    bool isGlobal = true,
    List<ExerciseMediaFile> mediaFiles = const [],
    List<String> exerciseTypes = const [],
    List<String> bodyParts = const [],
    List<String> inventory = const [],
  }) {
    return _repo.createExercise(
      name: name,
      description: description,
      steps: steps,
      type: type,
      isGlobal: isGlobal,
      mediaFiles: mediaFiles,
      exerciseTypes: exerciseTypes,
      bodyParts: bodyParts,
      inventory: inventory,
    );
  }
}