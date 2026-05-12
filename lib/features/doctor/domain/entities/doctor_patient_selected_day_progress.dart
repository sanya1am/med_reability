class DoctorPatientSelectedDayProgress {
  final int wellBeingRating;
  final int workoutDifficultyRating;
  final bool hadPain;
  final int painIntensityRating;

  const DoctorPatientSelectedDayProgress({
    required this.wellBeingRating,
    required this.workoutDifficultyRating,
    required this.hadPain,
    required this.painIntensityRating,
  });

  bool get hasProgress {
    return wellBeingRating > 0 &&
        workoutDifficultyRating > 0;
  }
}