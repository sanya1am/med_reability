import '../../domain/entities/clinic.dart';
import '../../domain/entities/role.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  final _clinics = const [
    Clinic(id: 'c1', name: 'Городская поликлиника №1'),
    Clinic(id: 'c2', name: 'Поликлиника “Здоровье”'),
    Clinic(id: 'c3', name: 'Реабилитационный центр “Восстановление”'),
  ];

  final _users = <_FakeUser>[
    _FakeUser(email: 'admin1@test.ru',  password: '123', role: UserRole.admin,  clinicId: 'c1', userId: 'u_admin_1'),
    _FakeUser(email: 'doctor1@test.ru', password: '123', role: UserRole.doctor, clinicId: 'c1', userId: 'u_doctor_1'),
    _FakeUser(email: 'patient1@test.ru',password: '123', role: UserRole.patient,clinicId: 'c1', userId: 'u_patient_1'),

    _FakeUser(email: 'admin2@test.ru', password: '123', role: UserRole.admin,  clinicId: 'c2', userId: 'u_admin_2'),
    _FakeUser(email: 'doctor2@test.ru', password: '123', role: UserRole.doctor, clinicId: 'c2', userId: 'u_doctor_2'),
    _FakeUser(email: 'patient2@test.ru',password: '123', role: UserRole.patient,clinicId: 'c2', userId: 'u_patient_2'),
  ];

  @override
  Future<List<Clinic>> searchClinics(String query) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return _clinics;
    return _clinics.where((c) => c.name.toLowerCase().contains(q)).toList();
  }

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
    required String clinicId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final user = _users.where((u) =>
    u.email.toLowerCase() == email.toLowerCase().trim() &&
        u.password == password &&
        u.clinicId == clinicId
    ).toList();

    if (user.isEmpty) {
      throw Exception('Неверные учетные данные');
    }

    final clinic = _clinics.firstWhere((c) => c.id == clinicId);
    final u = user.first;

    return AuthSession(
      token: 'fake-token-${u.userId}',
      clinic: clinic,
      role: u.role,
      userId: u.userId,
    );
  }

  @override
  Future<void> logout() async {}
}


class _FakeUser {
  final String email;
  final String password;
  final UserRole role;
  final String clinicId;
  final String userId;

  const _FakeUser({
    required this.email,
    required this.password,
    required this.role,
    required this.clinicId,
    required this.userId,
  });
}