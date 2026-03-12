import '../entities/clinic.dart';
import '../repositories/auth_repository.dart';

class SearchClinicsUseCase {
  final AuthRepository _repo;
  const SearchClinicsUseCase(this._repo);

  Future<List<Clinic>> call(String query) => _repo.searchClinics(query);
}