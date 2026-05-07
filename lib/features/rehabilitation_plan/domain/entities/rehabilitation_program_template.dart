import 'rehabilitation_program_day.dart';

class RehabilitationProgramWeekTemplate {
  final String id;
  final String name;
  final List<RehabilitationProgramDay> days;

  const RehabilitationProgramWeekTemplate({
    required this.id,
    required this.name,
    required this.days,
  });
}

class RehabilitationProgramDayTemplate {
  final String id;
  final String name;
  final RehabilitationProgramDay day;

  const RehabilitationProgramDayTemplate({
    required this.id,
    required this.name,
    required this.day,
  });
}