import '../entities/rehabilitation_program.dart';
import '../repositories/rehabilitation_program_repository.dart';

class GetRehabilitationProgramUseCase {
  final RehabilitationProgramRepository _repo;

  const GetRehabilitationProgramUseCase(this._repo);

  Future<RehabilitationProgram> call({
    required String id,
  }) {
    return _repo.getProgram(id: id);
  }
}