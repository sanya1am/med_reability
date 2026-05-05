class ExerciseFilterOptions {
  final List<String> trackingTypes;
  final List<String> exerciseTypes;
  final List<String> bodyParts;
  final List<String> inventory;

  const ExerciseFilterOptions({
    required this.trackingTypes,
    required this.exerciseTypes,
    required this.bodyParts,
    required this.inventory,
  });

  const ExerciseFilterOptions.empty()
      : trackingTypes = const [],
        exerciseTypes = const [],
        bodyParts = const [],
        inventory = const [];
}