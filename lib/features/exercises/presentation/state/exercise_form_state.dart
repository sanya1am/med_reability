import '../../domain/entities/exercise.dart';
import '../../domain/entities/exercise_media_file.dart';
import '../../domain/entities/exercise_type.dart';

class ExerciseFormState {
  final Exercise? initialExercise;
  final ExerciseType type;
  final bool isGlobal;
  final List<String> existingMediaUrls;
  final List<ExerciseMediaFile> pickedMediaFiles;
  final bool isSubmitting;
  final String? errorMessage;

  const ExerciseFormState({
    required this.initialExercise,
    required this.type,
    required this.isGlobal,
    required this.existingMediaUrls,
    required this.pickedMediaFiles,
    required this.isSubmitting,
    required this.errorMessage,
  });

  factory ExerciseFormState.fromExercise(Exercise? exercise) {
    return ExerciseFormState(
      initialExercise: exercise,
      type: exercise?.type ?? ExerciseType.repetition,
      isGlobal: exercise?.isGlobal ?? false,
      existingMediaUrls: exercise?.mediaUrls ?? const [],
      pickedMediaFiles: const [],
      isSubmitting: false,
      errorMessage: null,
    );
  }

  bool get isEdit => initialExercise != null;

  bool get requiresMediaReplacementConfirmation =>
      isEdit && existingMediaUrls.isNotEmpty && pickedMediaFiles.isEmpty;

  ExerciseFormState copyWith({
    Exercise? initialExercise,
    ExerciseType? type,
    bool? isGlobal,
    List<String>? existingMediaUrls,
    List<ExerciseMediaFile>? pickedMediaFiles,
    bool? isSubmitting,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ExerciseFormState(
      initialExercise: initialExercise ?? this.initialExercise,
      type: type ?? this.type,
      isGlobal: isGlobal ?? this.isGlobal,
      existingMediaUrls: existingMediaUrls ?? this.existingMediaUrls,
      pickedMediaFiles: pickedMediaFiles ?? this.pickedMediaFiles,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}