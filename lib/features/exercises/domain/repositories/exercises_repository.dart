import '../entities/exercise.dart';
import '../entities/exercise_filter_options.dart';
import '../entities/exercise_media_file.dart';
import '../entities/exercise_type.dart';

abstract class ExercisesRepository {
  Future<List<Exercise>> getExercises({
    required int pageNumber,
    required int pageSize,
    required bool all,
    String? search,
    List<ExerciseType>? types,
  });

  Future<Exercise> getExerciseById(String id);

  Future<Exercise> createExercise({
    required String name,
    required String description,
    required List<String> steps,
    required ExerciseType type,
    required bool isGlobal,
    List<ExerciseMediaFile> mediaFiles = const [],
  });

  Future<Exercise> updateExercise({
    required String id,
    required String name,
    required String description,
    required List<String> steps,
    required ExerciseType type,
    List<ExerciseMediaFile> mediaFiles = const [],
  });

  Future<void> deleteExercise(String id);

  Future<ExerciseFilterOptions> getFilterOptions();
}