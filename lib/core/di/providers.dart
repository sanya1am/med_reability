import 'dart:io' show Platform;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reability/core/network/dio_client.dart';
import 'package:med_reability/core/router/app_router.dart';
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

// use cases
final loginUseCaseProvider = Provider((ref) => LoginUseCase(ref.read(authRepositoryProvider)));
final logoutUseCaseProvider = Provider((ref) => LogoutUseCase(ref.read(authRepositoryProvider)));
final searchClinicsUseCaseProvider = Provider((ref) => SearchClinicsUseCase(ref.read(authRepositoryProvider)));