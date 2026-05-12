import 'dart:io' show Platform;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reability/core/network/dio_client.dart';
import 'package:med_reability/core/router/app_router.dart';
import 'package:med_reability/features/admin/data/repositories/doctor_patient_assignments_repository_impl.dart';
import 'package:med_reability/features/admin/data/repositories/users_repository_impl.dart';
import 'package:med_reability/features/admin/domain/repositories/doctor_patient_assignments_repository.dart';
import 'package:med_reability/features/admin/domain/repositories/users_repository.dart';
import 'package:med_reability/features/admin/domain/use_case/activate_user_use_case.dart';
import 'package:med_reability/features/admin/domain/use_case/assign_doctor_to_patient_use_case.dart';
import 'package:med_reability/features/admin/domain/use_case/create_user_use_case.dart';
import 'package:med_reability/features/admin/domain/use_case/deactivate_user_use_case.dart';
import 'package:med_reability/features/admin/domain/use_case/delete_assignment_use_case.dart';
import 'package:med_reability/features/admin/domain/use_case/get_assignments_use_case.dart';
import 'package:med_reability/features/admin/domain/use_case/list_users_use_case.dart';
import 'package:med_reability/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:med_reability/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:med_reability/features/auth/data/repositories/user_me_repository_impl.dart';
import 'package:med_reability/features/auth/domain/repositories/user_me_repository.dart';
import 'package:med_reability/features/auth/domain/use_case/get_user_me_use_case.dart';
import 'package:med_reability/features/doctor/data/repositories/doctor_patients_repository_impl.dart';
import 'package:med_reability/features/doctor/domain/repositories/doctor_patients_repository.dart';
import 'package:med_reability/features/doctor/domain/use_case/get_my_patient_use_case.dart';
import 'package:med_reability/features/exercises/data/repositories/exercises_repository_impl.dart';
import 'package:med_reability/features/exercises/domain/repositories/exercises_repository.dart';
import 'package:med_reability/features/exercises/domain/use_case/create_exercise_use_case.dart';
import 'package:med_reability/features/exercises/domain/use_case/get_exercise_by_id_use_case.dart';
import 'package:med_reability/features/exercises/domain/use_case/get_exercises_use_case.dart';
import 'package:med_reability/features/exercises/domain/use_case/update_exercise_use_case.dart';
import 'package:med_reability/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:med_reability/features/profile/domain/repositories/profile_repository.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/use_case/login_use_case.dart';
import '../../features/auth/domain/use_case/logout_use_case.dart';
import '../../features/auth/domain/use_case/search_clinics_use_case.dart';
import '../../features/doctor/data/repositories/doctor_patient_overview_repository_impl.dart';
import '../../features/doctor/domain/repositories/doctor_patient_overview_repository.dart';
import '../../features/doctor/domain/use_case/get_doctor_patient_overview_use_case.dart';
import '../../features/exercises/domain/use_case/delete_exercise_use_case.dart';
import '../../features/exercises/domain/use_case/get_exercise_filter_options_use_case.dart';
import '../../features/patient/data/repositories/patient_program_repository_impl.dart';
import '../../features/patient/domain/repositories/patient_program_repository.dart';
import '../../features/patient/domain/use_case/complete_patient_exercise_use_case.dart';
import '../../features/patient/domain/use_case/complete_patient_training_day_use_case.dart';
import '../../features/patient/domain/use_case/get_patient_program_overview_use_case.dart';
import '../../features/patient/domain/use_case/update_patient_day_progress_use_case.dart';
import '../../features/profile/domain/use_case/change_my_password_use_case.dart';
import '../../features/profile/domain/use_case/update_my_profile_use_case.dart';
import '../../features/rehabilitation_plan/data/repositories/rehabilitation_program_repository_impl.dart';
import '../../features/rehabilitation_plan/domain/repositories/rehabilitation_program_repository.dart';
import '../../features/rehabilitation_plan/domain/use_case/create_rehabilitation_program_use_case.dart';
import '../../features/rehabilitation_plan/domain/use_case/delete_rehabilitation_program_use_case.dart';
import '../../features/rehabilitation_plan/domain/use_case/get_rehabilitation_program_use_case.dart';
import '../../features/rehabilitation_plan/domain/use_case/update_rehabilitation_program_use_case.dart';
import '../services/theme_mode_storage.dart';
import '../services/token_storage.dart';
import '../theme/theme_mode_controller.dart';

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

// theme
final themeModeStorageProvider = Provider<ThemeModeStorage>((ref) {
  return ThemeModeStorage();
});
final themeModeProvider =
StateNotifierProvider<ThemeModeController, ThemeMode>((ref) {
  return ThemeModeController(
    ref.read(themeModeStorageProvider),
  );
});

// repo
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(dioProvider), ref.read(tokenStorageProvider)); // AuthRepositoryImpl() или FakeAuthRepository()
});
final userMeRepositoryProvider = Provider<UserMeRepository>((ref) {
  return UserMeRepositoryImpl(ref.read(dioProvider), ref.read(tokenStorageProvider));
});
final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  return UsersRepositoryImpl(ref.read(dioProvider), ref.read(tokenStorageProvider));
});
final assignmentsRepositoryProvider = Provider<DoctorPatientAssignmentsRepository>((ref) {
  return DoctorPatientAssignmentsRepositoryImpl(ref.read(dioProvider), ref.read(tokenStorageProvider));
});
final doctorPatientsRepositoryProvider = Provider<DoctorPatientsRepository>((ref) {
  return DoctorPatientsRepositoryImpl(ref.read(dioProvider), ref.read(tokenStorageProvider));
});
final exercisesRepositoryProvider = Provider<ExercisesRepository>((ref) {
  return ExercisesRepositoryImpl(ref.read(dioProvider), ref.read(tokenStorageProvider));
});
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(ref.read(dioProvider), ref.read(tokenStorageProvider));
});
final doctorPatientOverviewRepositoryProvider = Provider<DoctorPatientOverviewRepository>((ref) {
  return DoctorPatientOverviewRepositoryImpl(ref.read(dioProvider), ref.read(tokenStorageProvider));
});
final rehabilitationProgramRepositoryProvider = Provider<RehabilitationProgramRepository>((ref) {
  return RehabilitationProgramRepositoryImpl(ref.read(dioProvider), ref.read(tokenStorageProvider));
});
final patientProgramRepositoryProvider = Provider<PatientProgramRepository>((ref) {
  return PatientProgramRepositoryImpl(ref.read(dioProvider), ref.read(tokenStorageProvider));
});

// use cases
final loginUseCaseProvider = Provider((ref) => LoginUseCase(ref.read(authRepositoryProvider)));
final logoutUseCaseProvider = Provider((ref) => LogoutUseCase(ref.read(authRepositoryProvider)));
final searchClinicsUseCaseProvider = Provider((ref) => SearchClinicsUseCase(ref.read(authRepositoryProvider)));
final getUserMeUseCaseProvider = Provider((ref) => GetUserMeUseCase(ref.read(userMeRepositoryProvider)));
final listUsersUseCaseProvider = Provider((ref) => ListUsersUseCase(ref.read(usersRepositoryProvider)));
final createUserUseCaseProvider = Provider((ref) => CreateUserUseCase(ref.read(usersRepositoryProvider)));
final deactivateUserUseCaseProvider = Provider((ref) => DeactivateUserUseCase(ref.read(usersRepositoryProvider)));
final activateUserUseCaseProvider = Provider((ref) => ActivateUserUseCase(ref.read(usersRepositoryProvider)));
final getAssignmentsUseCaseProvider = Provider((ref) => GetAssignmentsUseCase(ref.read(assignmentsRepositoryProvider)));
final assignDoctorToPatientUseCaseProvider = Provider((ref) => AssignDoctorToPatientUseCase(ref.read(assignmentsRepositoryProvider)));
final deleteAssignmentUseCaseProvider = Provider((ref) => DeleteAssignmentUseCase(ref.read(assignmentsRepositoryProvider)));
final getMyPatientsUseCaseProvider = Provider((ref) => GetMyPatientsUseCase(ref.read(doctorPatientsRepositoryProvider)));
final getExercisesUseCaseProvider = Provider((ref) => GetExercisesUseCase(ref.read(exercisesRepositoryProvider)));
final createExerciseUseCaseProvider = Provider((ref) => CreateExerciseUseCase(ref.read(exercisesRepositoryProvider)));
final deleteExerciseUseCaseProvider = Provider((ref) => DeleteExerciseUseCase(ref.read(exercisesRepositoryProvider)));
final getExerciseByIdUseCaseProvider = Provider((ref) => GetExerciseByIdUseCase(ref.read(exercisesRepositoryProvider)));
final updateExerciseUseCaseProvider = Provider((ref) => UpdateExerciseUseCase(ref.read(exercisesRepositoryProvider)));
final updateMyProfileUseCaseProvider = Provider((ref) => UpdateMyProfileUseCase(ref.read(profileRepositoryProvider)));
final changeMyPasswordUseCaseProvider = Provider((ref) => ChangeMyPasswordUseCase(ref.read(profileRepositoryProvider)));
final getDoctorPatientOverviewUseCaseProvider = Provider((ref) => GetDoctorPatientOverviewUseCase(ref.read(doctorPatientOverviewRepositoryProvider)));
final getExerciseFilterOptionsUseCaseProvider = Provider((ref) => GetExerciseFilterOptionsUseCase(ref.read(exercisesRepositoryProvider)));
final createRehabilitationProgramUseCaseProvider = Provider((ref) => CreateRehabilitationProgramUseCase(ref.read(rehabilitationProgramRepositoryProvider)));
final updateRehabilitationProgramUseCaseProvider = Provider((ref) => UpdateRehabilitationProgramUseCase(ref.read(rehabilitationProgramRepositoryProvider)));
final getRehabilitationProgramUseCaseProvider = Provider((ref) => GetRehabilitationProgramUseCase(ref.read(rehabilitationProgramRepositoryProvider)));
final deleteRehabilitationProgramUseCaseProvider = Provider((ref) => DeleteRehabilitationProgramUseCase(ref.read(rehabilitationProgramRepositoryProvider)));
final getPatientProgramOverviewUseCaseProvider = Provider((ref) => GetPatientProgramOverviewUseCase(ref.read(patientProgramRepositoryProvider)));
final completePatientExerciseUseCaseProvider = Provider((ref) => CompletePatientExerciseUseCase(ref.read(patientProgramRepositoryProvider)));
final completePatientTrainingDayUseCaseProvider = Provider((ref) => CompletePatientTrainingDayUseCase(ref.read(patientProgramRepositoryProvider)));
final updatePatientDayProgressUseCaseProvider = Provider((ref) => UpdatePatientDayProgressUseCase(ref.read(patientProgramRepositoryProvider)));
