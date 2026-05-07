import '../repositories/rehabilitation_program_repository.dart';

class DeleteRehabilitationProgramUseCase {
  final RehabilitationProgramRepository _repo;

  const DeleteRehabilitationProgramUseCase(this._repo);

  Future<void> call({
    required String id,
  }) {
    return _repo.deleteProgram(id: id);
  }
}