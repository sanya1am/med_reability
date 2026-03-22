import 'dart:io' show Platform;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reability/core/network/dio_client.dart';
import 'package:med_reability/core/router/app_router.dart';
import 'package:med_reability/features/admin/data/repositories/users_repository_impl.dart';
import 'package:med_reability/features/admin/domain/repositories/users_repository.dart';
import 'package:med_reability/features/admin/domain/use_case/create_user_use_case.dart';
import 'package:med_reability/features/admin/domain/use_case/deactivate_user_use_case.dart';
import 'package:med_reability/features/admin/domain/use_case/list_users_use_case.dart';
import 'package:med_reability/features/auth/data/repositroties/auth_repository_impl.dart';
import 'package:med_reability/features/auth/data/repositroties/fake_auth_repository.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/use_case/login_use_case.dart';
import '../../features/auth/domain/use_case/logout_use_case.dart';
import '../../features/auth/domain/use_case/search_clinics_use_case.dart';
import '../services/token_storage.dart';

final baseUrlProvider = Provider<String>((_) {
  if (kIsWeb) return 'http://localhost:8080'; // web
  if (Platform.isAndroid) return 'http://10.0.2.2:8080'; // android
  return 'http://localhost:8080'; // ios simulator
});

final dioProvider = Provider<Dio>((ref) {
  return buildDio(ref.read(baseUrlProvider));
});
final tokenStorageProvider = Provider<TokenStorage>((_) => TokenStorage());

// app
final appRouterProvider = Provider<GoRouter>((ref) => buildRouter(ref));

// repo
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(dioProvider), ref.read(tokenStorageProvider)); // AuthRepositoryImpl() или FakeAuthRepository()
});
final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  return UsersRepositoryImpl(ref.read(dioProvider), ref.read(tokenStorageProvider));
});

// use cases
final loginUseCaseProvider = Provider((ref) => LoginUseCase(ref.read(authRepositoryProvider)));
final logoutUseCaseProvider = Provider((ref) => LogoutUseCase(ref.read(authRepositoryProvider)));
final searchClinicsUseCaseProvider = Provider((ref) => SearchClinicsUseCase(ref.read(authRepositoryProvider)));
final listUsersUseCaseProvider = Provider((ref) => ListUsersUseCase(ref.read(usersRepositoryProvider)));
final createUserUseCaseProvider = Provider((ref) => CreateUserUseCase(ref.read(usersRepositoryProvider)));
final deactivateUserUseCaseProvider = Provider((ref) => DeactivateUserUseCase(ref.read(usersRepositoryProvider)));