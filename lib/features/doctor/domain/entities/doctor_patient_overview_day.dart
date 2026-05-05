class DoctorPatientOverviewDay {
  final DateTime date;
  final int dayNumber;
  final String dayType;
  final bool hasTraining;
  final bool isCompleted;
  final int? stateRating;
  final String? notes;

  const DoctorPatientOverviewDay({
    required this.date,
    required this.dayNumber,
    required this.dayType,
    required this.hasTraining,
    required this.isCompleted,
    required this.stateRating,
    required this.notes,
  });
}