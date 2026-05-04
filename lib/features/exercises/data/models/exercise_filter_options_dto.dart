import '../../domain/entities/exercise_filter_options.dart';

class ExerciseFilterOptionsDto {
  final List<String> trackingTypes;
  final List<String> exerciseTypes;
  final List<String> bodyParts;
  final List<String> inventory;

  const ExerciseFilterOptionsDto({
    required this.trackingTypes,
    required this.exerciseTypes,
    required this.bodyParts,
    required this.inventory,
  });

  factory ExerciseFilterOptionsDto.fromJson(Map<String, dynamic> json) {
    return ExerciseFilterOptionsDto(
      trackingTypes: _parseStringList(json['trackingTypes']),
      exerciseTypes: _parseStringList(json['exerciseTypes']),
      bodyParts: _parseStringList(json['bodyParts']),
      inventory: _parseStringList(json['inventory']),
    );
  }

  static List<String> _parseStringList(dynamic raw) {
    if (raw is! List) return const [];

    return raw
        .map((e) => e?.toString())
        .whereType<String>()
        .where((e) => e.trim().isNotEmpty)
        .toList();
  }

  ExerciseFilterOptions toEntity() {
    return ExerciseFilterOptions(
      trackingTypes: trackingTypes,
      exerciseTypes: exerciseTypes,
      bodyParts: bodyParts,
      inventory: inventory,
    );
  }
}