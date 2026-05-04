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

  final List<String> exerciseTypes;
  final List<String> bodyParts;
  final List<String> inventory;

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
    required this.exerciseTypes,
    required this.bodyParts,
    required this.inventory,
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
    exerciseTypes: _parseStringList(json['exerciseTypes']),
    bodyParts: _parseStringList(json['bodyParts']),
    inventory: _parseStringList(json['inventory']),
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

  static List<String> _parseStringList(dynamic raw) {
    if (raw is! List) return const [];

    return raw
        .map((e) => e?.toString())
        .whereType<String>()
        .where((e) => e.trim().isNotEmpty)
        .toList();
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
    exerciseTypes: exerciseTypes,
    bodyParts: bodyParts,
    inventory: inventory,
    steps: steps,
  );
}