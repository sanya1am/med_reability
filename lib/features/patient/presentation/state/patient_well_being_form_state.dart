class PatientWellBeingFormState {
  final int wellBeingRating;
  final int workoutDifficultyRating;
  final bool hadPain;
  final int painIntensityRating;
  final bool isSubmitting;
  final String? errorMessage;

  const PatientWellBeingFormState({
    required this.wellBeingRating,
    required this.workoutDifficultyRating,
    required this.hadPain,
    required this.painIntensityRating,
    required this.isSubmitting,
    required this.errorMessage,
  });

  const PatientWellBeingFormState.initial()
      : wellBeingRating = 1,
        workoutDifficultyRating = 1,
        hadPain = false,
        painIntensityRating = 1,
        isSubmitting = false,
        errorMessage = null;

  PatientWellBeingFormState copyWith({
    int? wellBeingRating,
    int? workoutDifficultyRating,
    bool? hadPain,
    int? painIntensityRating,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PatientWellBeingFormState(
      wellBeingRating: wellBeingRating ?? this.wellBeingRating,
      workoutDifficultyRating:
      workoutDifficultyRating ?? this.workoutDifficultyRating,
      hadPain: hadPain ?? this.hadPain,
      painIntensityRating: painIntensityRating ?? this.painIntensityRating,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}


class PatientWellBeingFormArgs {
  final String planId;
  final int dayNumber;

  const PatientWellBeingFormArgs({
    required this.planId,
    required this.dayNumber,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PatientWellBeingFormArgs &&
            other.planId == planId &&
            other.dayNumber == dayNumber;
  }

  @override
  int get hashCode => Object.hash(planId, dayNumber);
}