class PatientProgramProgress {
  final int completedDaysCount;
  final int plannedTrainingDaysCount;
  final int completionPercent;

  const PatientProgramProgress({
    required this.completedDaysCount,
    required this.plannedTrainingDaysCount,
    required this.completionPercent,
  });
}