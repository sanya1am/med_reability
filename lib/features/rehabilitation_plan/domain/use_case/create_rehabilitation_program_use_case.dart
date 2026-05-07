import '../entities/rehabilitation_program.dart';
import '../entities/rehabilitation_program_day.dart';
import '../repositories/rehabilitation_program_repository.dart';

class CreateRehabilitationProgramUseCase {
  final RehabilitationProgramRepository _repo;

  const CreateRehabilitationProgramUseCase(this._repo);

  Future<RehabilitationProgram> call({
    required String patientId,
    required String name,
    required String description,
    required DateTime startDate,
    required List<RehabilitationProgramDay> days,
  }) {
    return _repo.createProgram(
      patientId: patientId,
      name: name,
      description: description,
      startDate: startDate,
      days: days,
    );
  }
}