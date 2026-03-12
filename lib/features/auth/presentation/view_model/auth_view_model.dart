import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/auth_ui_state.dart';
import '../../domain/entities/clinic.dart';
import '../../domain/use_case/login_use_case.dart';
import '../../domain/use_case/logout_use_case.dart';
import '../../domain/use_case/search_clinics_use_case.dart';
import '../../../../core/di/providers.dart';

class AuthViewModel extends Notifier<AuthUiState> {
  late final LoginUseCase _login;
  late final LogoutUseCase _logout;
  late final SearchClinicsUseCase _searchClinics;

  @override
  AuthUiState build() {
    _login = ref.read(loginUseCaseProvider);
    _logout = ref.read(logoutUseCaseProvider);
    _searchClinics = ref.read(searchClinicsUseCaseProvider);
    return const AuthUiState.initial();
  }

  void setEmail(String v) => state = state.copyWith(email: v, error: null);
  void setPassword(String v) => state = state.copyWith(password: v, error: null);
  void setClinic(Clinic c) => state = state.copyWith(selectedClinic: c, error: null);

  Future<List<Clinic>> searchClinics(String q) => _searchClinics(q);

  Future<void> login() async {
    if (state.selectedClinic == null) {
      state = state.copyWith(error: 'Выберите поликлинику');
      return;
    }
    if (state.email.trim().isEmpty || state.password.isEmpty) {
      state = state.copyWith(error: 'Введите почту и пароль');
      return;
    }

    state = state.copyWith(loading: true, error: null);
    try {
      final session = await _login(
        email: state.email.trim(),
        password: state.password,
        clinicId: state.selectedClinic!.id,
      );
      state = state.copyWith(loading: false, session: session);
    } catch (_) {
      state = state.copyWith(loading: false, error: 'Ошибка входа');
    }
  }

  Future<void> logout() async {
    await _logout();
    state = const AuthUiState.initial();
  }
}

final authViewModelProvider =
NotifierProvider<AuthViewModel, AuthUiState>(AuthViewModel.new);