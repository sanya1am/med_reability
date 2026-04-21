import '../../domain/entities/exercise.dart';
import '../../domain/entities/exercise_type.dart';
import 'package:med_reability/core/services/media_url_helper.dart';


class ExerciseDto {
  final String id;
  final String clinicId;
  final String? userId;
  final String name;
  final String description;
  final List<String> mediaUrls;
  final bool isDeleted;
  final String type;
  final List<String> steps;

  ExerciseDto({
    required this.id,
    required this.clinicId,
    required this.userId,
    required this.name,
    required this.description,
    required this.mediaUrls,
    required this.isDeleted,
    required this.type,
    required this.steps,
  });

  factory ExerciseDto.fromJson(Map<String, dynamic> json) => ExerciseDto(
    id: (json['id'] as String?) ?? '',
    clinicId: (json['clinicId'] as String?) ?? '',
    userId: json['userId'] as String?,
    name: (json['name'] as String?) ?? '',
    description: (json['description'] as String?) ?? '',
    mediaUrls: _parseMediaUrls(json),
    isDeleted: (json['isDeleted'] as bool?) ?? false,
    type: (json['type'] as String?) ?? 'Repetition',
    steps: ((json['steps'] as List?) ?? const [])
        .map((e) => e.toString())
        .toList(),
  );

  static List<String> _parseMediaUrls(Map<String, dynamic> json) {
    final raw = json['mediaUrls'];
    if (raw == null) return const [];

    if (raw is List) {
      return raw
          .map((e) => e?.toString())
          .whereType<String>()
          .where((e) => e.isNotEmpty)
          .map(normalizeMediaUrl)
          .toList();
    }

    return const [];
  }

  Exercise toEntity() => Exercise(
    id: id,
    clinicId: clinicId,
    userId: userId,
    name: name,
    description: description,
    mediaUrls: mediaUrls,
    isDeleted: isDeleted,
    type: exerciseTypeFromApi(type),
    steps: steps,
  );
}