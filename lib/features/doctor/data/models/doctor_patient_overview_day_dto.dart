import '../../domain/entities/doctor_patient_overview_day.dart';

class DoctorPatientOverviewDayDto {
  final DateTime date;
  final int dayNumber;
  final String dayType;
  final bool hasTraining;
  final bool isCompleted;
  final int? stateRating;
  final String? notes;

  const DoctorPatientOverviewDayDto({
    required this.date,
    required this.dayNumber,
    required this.dayType,
    required this.hasTraining,
    required this.isCompleted,
    required this.stateRating,
    required this.notes,
  });

  factory DoctorPatientOverviewDayDto.fromJson(Map<String, dynamic> json) {
    return DoctorPatientOverviewDayDto(
      date: DateTime.tryParse((json['date'] as String?) ?? '') ??
          DateTime.now(),
      dayNumber: (json['dayNumber'] as num?)?.toInt() ?? 0,
      dayType: (json['dayType'] as String?) ?? '',
      hasTraining: (json['hasTraining'] as bool?) ?? false,
      isCompleted: (json['isCompleted'] as bool?) ?? false,
      stateRating: (json['stateRating'] as num?)?.toInt(),
      notes: json['notes'] as String?,
    );
  }

  DoctorPatientOverviewDay toEntity() {
    return DoctorPatientOverviewDay(
      date: date,
      dayNumber: dayNumber,
      dayType: dayType,
      hasTraining: hasTraining,
      isCompleted: isCompleted,
      stateRating: stateRating,
      notes: notes,
    );
  }
}