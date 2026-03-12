import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reability/core/router/app_router.dart';
import 'package:med_reability/features/auth/data/repositroties/fake_auth_repository.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/use_case/login_use_case.dart';
import '../../features/auth/domain/use_case/logout_use_case.dart';
import '../../features/auth/domain/use_case/search_clinics_use_case.dart';

// app
final appRouterProvider = Provider<GoRouter>((ref) => buildRouter(ref));

// repo
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FakeAuthRepository(); // AuthRepositoryImpl() или FakeAuthRepository()
});

// use cases
final loginUseCaseProvider = Provider((ref) => LoginUseCase(ref.read(authRepositoryProvider)));
final logoutUseCaseProvider = Provider((ref) => LogoutUseCase(ref.read(authRepositoryProvider)));
final searchClinicsUseCaseProvider = Provider((ref) => SearchClinicsUseCase(ref.read(authRepositoryProvider)));