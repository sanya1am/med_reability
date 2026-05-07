import '../../domain/entities/rehabilitation_program.dart';
import 'rehabilitation_program_day_dto.dart';

class RehabilitationProgramDto {
  final String id;
  final String clinicId;
  final String patientId;
  final String createdByUserId;
  final String name;
  final String description;
  final DateTime startDate;
  final String status;
  final bool isDeleted;
  final List<RehabilitationProgramDayDto> days;

  const RehabilitationProgramDto({
    required this.id,
    required this.clinicId,
    required this.patientId,
    required this.createdByUserId,
    required this.name,
    required this.description,
    required this.startDate,
    required this.status,
    required this.isDeleted,
    required this.days,
  });

  factory RehabilitationProgramDto.fromJson(Map<String, dynamic> json) {
    final daysRaw = (json['days'] as List?) ?? const [];

    return RehabilitationProgramDto(
      id: (json['id'] as String?) ?? '',
      clinicId: (json['clinicId'] as String?) ?? '',
      patientId: (json['patientId'] as String?) ?? '',
      createdByUserId: (json['createdByUserId'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      startDate: DateTime.tryParse((json['startDate'] as String?) ?? '') ??
          DateTime.now(),
      status: (json['status'] as String?) ?? '',
      isDeleted: (json['isDeleted'] as bool?) ?? false,
      days: daysRaw
          .whereType<Map<String, dynamic>>()
          .map(RehabilitationProgramDayDto.fromJson)
          .toList(),
    );
  }

  RehabilitationProgram toEntity() {
    return RehabilitationProgram(
      id: id,
      clinicId: clinicId,
      patientId: patientId,
      createdByUserId: createdByUserId,
      name: name,
      description: description,
      startDate: startDate,
      status: status,
      isDeleted: isDeleted,
      days: days.map((x) => x.toEntity()).toList(),
    );
  }
}