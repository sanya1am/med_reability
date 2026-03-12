import '../../domain/entities/clinic.dart';
import '../../domain/entities/session.dart';

class AuthUiState {
  final bool loading;
  final String? error;

  final String email;
  final String password;
  final Clinic? selectedClinic;

  final AuthSession? session;

  const AuthUiState({
    required this.loading,
    required this.error,
    required this.email,
    required this.password,
    required this.selectedClinic,
    required this.session,
  });

  const AuthUiState.initial()
      : loading = false,
        error = null,
        email = '',
        password = '',
        selectedClinic = null,
        session = null;

  bool get isAuthed => session != null;

  AuthUiState copyWith({
    bool? loading,
    Object? error = _unset,
    String? email,
    String? password,
    Clinic? selectedClinic,
    AuthSession? session,
  }) {
    return AuthUiState(
      loading: loading ?? this.loading,
      error: error == _unset ? this.error : error as String?,
      email: email ?? this.email,
      password: password ?? this.password,
      selectedClinic: selectedClinic ?? this.selectedClinic,
      session: session ?? this.session,
    );
  }

  static const _unset = Object();
}