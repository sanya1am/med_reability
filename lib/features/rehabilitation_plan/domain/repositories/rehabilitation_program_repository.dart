import '../entities/rehabilitation_program.dart';
import '../entities/rehabilitation_program_day.dart';

abstract class RehabilitationProgramRepository {
  Future<RehabilitationProgram> createProgram({
    required String patientId,
    required String name,
    required String description,
    required DateTime startDate,
    required List<RehabilitationProgramDay> days,
  });

  Future<RehabilitationProgram> updateProgram({
    required String id,
    required String name,
    required String description,
    required DateTime startDate,
    required List<RehabilitationProgramDay> days,
  });

  Future<RehabilitationProgram> getProgram({
    required String id,
  });

  Future<void> deleteProgram({
    required String id,
  });
}