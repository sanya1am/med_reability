import 'exercise_type.dart';

class Exercise {
  final String id;
  final String clinicId;
  final String? userId; // null => global
  final String name;
  final String description;
  final List<String> mediaUrls;
  final bool isDeleted;
  final ExerciseType type;
  final List<String> steps;

  const Exercise({
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

  bool get isGlobal => userId == null;
}