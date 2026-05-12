import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/core/di/providers.dart';
import 'package:med_reability/core/errors/unauthorized_exception.dart';
import 'package:med_reability/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:med_reability/features/patient/presentation/state/patient_well_being_form_state.dart';


class PatientWellBeingFormViewModel
    extends FamilyNotifier<PatientWellBeingFormState, PatientWellBeingFormArgs> {
  late final _updateProgress = ref.read(updatePatientDayProgressUseCaseProvider);

  late PatientWellBeingFormArgs _args;

  @override
  PatientWellBeingFormState build(PatientWellBeingFormArgs arg) {
    _args = arg;
    return const PatientWellBeingFormState.initial();
  }

  void setWellBeingRating(int value) {
    state = state.copyWith(
      wellBeingRating: value,
      clearError: true,
    );
  }

  void setWorkoutDifficultyRating(int value) {
    state = state.copyWith(
      workoutDifficultyRating: value,
      clearError: true,
    );
  }

  void setHadPain(bool value) {
    state = state.copyWith(
      hadPain: value,
      painIntensityRating: value ? state.painIntensityRating : 1,
      clearError: true,
    );
  }

  void setPainIntensityRating(int value) {
    state = state.copyWith(
      painIntensityRating: value,
      clearError: true,
    );
  }

  Future<bool> submit() async {
    if (state.isSubmitting) return false;

    state = state.copyWith(
      isSubmitting: true,
      clearError: true,
    );

    final result = await AsyncValue.guard(() {
      return _updateProgress(
        planId: _args.planId,
        dayNumber: _args.dayNumber,
        wellBeingRating: state.wellBeingRating,
        workoutDifficultyRating: state.workoutDifficultyRating,
        hadPain: state.hadPain,
        painIntensityRating: state.hadPain ? state.painIntensityRating : 1,
      );
    });

    if (result.hasError) {
      final error = result.error;

      if (error is UnauthorizedException) {
        await ref.read(authViewModelProvider.notifier).logout();
        return false;
      }

      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.toString(),
      );

      return false;
    }

    state = state.copyWith(
      isSubmitting: false,
      clearError: true,
    );

    return true;
  }
}

final patientWellBeingFormViewModelProvider = NotifierProvider.family<
    PatientWellBeingFormViewModel,
    PatientWellBeingFormState,
    PatientWellBeingFormArgs>(
  PatientWellBeingFormViewModel.new,
);