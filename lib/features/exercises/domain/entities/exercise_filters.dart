enum ExerciseAccessFilter {
  all,
  global,
  mine,
}

class ExerciseFilters {
  final ExerciseAccessFilter access;
  final List<String> trackingTypes;
  final List<String> exerciseTypes;
  final List<String> bodyParts;
  final List<String> inventory;

  const ExerciseFilters({
    this.access = ExerciseAccessFilter.all,
    this.trackingTypes = const [],
    this.exerciseTypes = const [],
    this.bodyParts = const [],
    this.inventory = const [],
  });

  bool get hasActiveFilters {
    return access != ExerciseAccessFilter.all ||
        trackingTypes.isNotEmpty ||
        exerciseTypes.isNotEmpty ||
        bodyParts.isNotEmpty ||
        inventory.isNotEmpty;
  }

  ExerciseFilters copyWith({
    ExerciseAccessFilter? access,
    List<String>? trackingTypes,
    List<String>? exerciseTypes,
    List<String>? bodyParts,
    List<String>? inventory,
  }) {
    return ExerciseFilters(
      access: access ?? this.access,
      trackingTypes: trackingTypes ?? this.trackingTypes,
      exerciseTypes: exerciseTypes ?? this.exerciseTypes,
      bodyParts: bodyParts ?? this.bodyParts,
      inventory: inventory ?? this.inventory,
    );
  }
}