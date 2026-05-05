import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/errors/unauthorized_exception.dart';
import '../../../auth/presentation/view_model/auth_view_model.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/exercise_media_file.dart';
import '../../domain/entities/exercise_type.dart';
import '../state/exercise_form_state.dart';

class ExerciseFormSubmitResult {
  final bool isSuccess;
  final String? errorMessage;

  const ExerciseFormSubmitResult._({
    required this.isSuccess,
    this.errorMessage,
  });

  const ExerciseFormSubmitResult.success() : this._(isSuccess: true);

  const ExerciseFormSubmitResult.failure(String message)
      : this._(
    isSuccess: false,
    errorMessage: message,
  );
}

class ExerciseFormViewModel extends StateNotifier<ExerciseFormState> {
  final Ref ref;

  ExerciseFormViewModel(
      this.ref,
      Exercise? initialExercise,
      ) : super(ExerciseFormState.fromExercise(initialExercise));

  late final createExerciseUseCase = ref.read(createExerciseUseCaseProvider);
  late final updateExerciseUseCase = ref.read(updateExerciseUseCaseProvider);

  void setType(ExerciseType? value) {
    if (value == null) return;
    state = state.copyWith(
      type: value,
      clearErrorMessage: true,
    );
  }

  void setIsGlobal(bool value) {
    state = state.copyWith(
      isGlobal: value,
      clearErrorMessage: true,
    );
  }

  void setPickedMediaFiles(List<ExerciseMediaFile> files) {
    state = state.copyWith(
      pickedMediaFiles: List<ExerciseMediaFile>.unmodifiable(files),
      clearErrorMessage: true,
    );
  }

  void removePickedMediaAt(int index) {
    if (index < 0 || index >= state.pickedMediaFiles.length) return;

    final next = List<ExerciseMediaFile>.from(state.pickedMediaFiles)
      ..removeAt(index);

    state = state.copyWith(
      pickedMediaFiles: List<ExerciseMediaFile>.unmodifiable(next),
      clearErrorMessage: true,
    );
  }

  Future<ExerciseFormSubmitResult> submit({
    required String name,
    required String description,
    required List<String> steps,
  }) async {
    final trimmedName = name.trim();
    final trimmedDescription = description.trim();
    final cleanedSteps = steps
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList(growable: false);

    if (trimmedName.isEmpty ||
        trimmedDescription.isEmpty ||
        cleanedSteps.isEmpty) {
      return const ExerciseFormSubmitResult.failure(
        'Заполните название, описание и хотя бы один шаг',
      );
    }

    if (state.isSubmitting) {
      return const ExerciseFormSubmitResult.failure(
        'Сохранение уже выполняется',
      );
    }

    state = state.copyWith(
      isSubmitting: true,
      clearErrorMessage: true,
    );

    try {
      if (state.isEdit) {
        await updateExerciseUseCase(
          id: state.initialExercise!.id,
          name: trimmedName,
          description: trimmedDescription,
          steps: cleanedSteps,
          type: state.type,
          mediaFiles: state.pickedMediaFiles,
          exerciseTypes: state.exerciseTypes,
          bodyParts: state.bodyParts,
          inventory: state.inventory,
        );
      } else {
        await createExerciseUseCase(
          name: trimmedName,
          description: trimmedDescription,
          steps: cleanedSteps,
          type: state.type,
          isGlobal: state.isGlobal,
          mediaFiles: state.pickedMediaFiles,
          exerciseTypes: state.exerciseTypes,
          bodyParts: state.bodyParts,
          inventory: state.inventory,
        );
      }

      state = state.copyWith(
        isSubmitting: false,
        clearErrorMessage: true,
        exerciseTypes: state.exerciseTypes,
        bodyParts: state.bodyParts,
        inventory: state.inventory,
      );

      return const ExerciseFormSubmitResult.success();
    } on UnauthorizedException {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Сессия истекла',
      );
      await ref.read(authViewModelProvider.notifier).logout();
      return const ExerciseFormSubmitResult.failure('Сессия истекла');
    } catch (e) {
      final message = 'Не удалось сохранить упражнение: $e';

      state = state.copyWith(
        isSubmitting: false,
        errorMessage: message,
      );

      return ExerciseFormSubmitResult.failure(message);
    }
  }

  void toggleExerciseType(String value) {
    final next = List<String>.from(state.exerciseTypes);

    if (next.contains(value)) {
      next.remove(value);
    } else {
      next.add(value);
    }

    state = state.copyWith(
      exerciseTypes: List<String>.unmodifiable(next),
      clearErrorMessage: true,
    );
  }

  void toggleBodyPart(String value) {
    final next = List<String>.from(state.bodyParts);

    if (next.contains(value)) {
      next.remove(value);
    } else {
      next.add(value);
    }

    state = state.copyWith(
      bodyParts: List<String>.unmodifiable(next),
      clearErrorMessage: true,
    );
  }

  void toggleInventory(String value) {
    final next = List<String>.from(state.inventory);

    if (next.contains(value)) {
      next.remove(value);
    } else {
      next.add(value);
    }

    state = state.copyWith(
      inventory: List<String>.unmodifiable(next),
      clearErrorMessage: true,
    );
  }
}

final exerciseFormViewModelProvider = StateNotifierProvider.autoDispose
    .family<ExerciseFormViewModel, ExerciseFormState, Exercise?>(
      (ref, initialExercise) => ExerciseFormViewModel(ref, initialExercise),
);