class DoctorPatientOverviewProgress {
  final int completedDaysCount;
  final int plannedTrainingDaysCount;
  final int completionPercent;

  const DoctorPatientOverviewProgress({
    required this.completedDaysCount,
    required this.plannedTrainingDaysCount,
    required this.completionPercent,
  });
}