class PatientProgramDay {
  final DateTime date;
  final int dayNumber;
  final String dayType;
  final bool hasTraining;
  final bool isCompleted;
  final int wellBeingRating;
  final int workoutDifficultyRating;
  final bool hadPain;
  final int painIntensityRating;

  const PatientProgramDay({
    required this.date,
    required this.dayNumber,
    required this.dayType,
    required this.hasTraining,
    required this.isCompleted,
    required this.wellBeingRating,
    required this.workoutDifficultyRating,
    required this.hadPain,
    required this.painIntensityRating,
  });
}