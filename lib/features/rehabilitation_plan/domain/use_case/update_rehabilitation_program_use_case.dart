import '../entities/rehabilitation_program.dart';
import '../entities/rehabilitation_program_day.dart';
import '../repositories/rehabilitation_program_repository.dart';

class UpdateRehabilitationProgramUseCase {
  final RehabilitationProgramRepository _repo;

  const UpdateRehabilitationProgramUseCase(this._repo);

  Future<RehabilitationProgram> call({
    required String id,
    required String name,
    required String description,
    required DateTime startDate,
    required List<RehabilitationProgramDay> days,
  }) {
    return _repo.updateProgram(
      id: id,
      name: name,
      description: description,
      startDate: startDate,
      days: days,
    );
  }
}