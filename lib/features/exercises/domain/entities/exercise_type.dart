enum ExerciseType { repetition, time }

ExerciseType exerciseTypeFromApi(String v) {
  switch (v.toLowerCase()) {
    case 'time':
      return ExerciseType.time;
    default:
      return ExerciseType.repetition;
  }
}

String exerciseTypeToApi(ExerciseType t) {
  return switch (t) {
    ExerciseType.repetition => 'Repetition',
    ExerciseType.time => 'Time',
  };
}

String exerciseTypeLabel(ExerciseType t) {
  return switch (t) {
    ExerciseType.repetition => 'На повторения',
    ExerciseType.time => 'На время',
  };
}