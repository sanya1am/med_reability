import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/features/admin/presentation/state/users_state.dart';
import 'package:med_reability/features/auth/domain/entities/role.dart';
import 'package:med_reability/features/auth/presentation/view_model/auth_view_model.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/di/session_scope.dart';
import '../../../../core/errors/unauthorized_exception.dart';


class UsersViewModel extends AsyncNotifier<UsersState> {
  late final listUsers = ref.read(listUsersUseCaseProvider);
  late final createUser = ref.read(createUserUseCaseProvider);
  late final deactivateUser = ref.read(deactivateUserUseCaseProvider);
  late final activateUser = ref.read(activateUserUseCaseProvider);
  late final getAssignments = ref.read(getAssignmentsUseCaseProvider);
  late final assignDoctor = ref.read(assignDoctorToPatientUseCaseProvider);
  late final deleteAssignment = ref.read(deleteAssignmentUseCaseProvider);

  @override
  Future<UsersState> build() async {
    ref.watch(sessionEpochProvider);

    try {
      return _load(pageNumber: 1, pageSize: 50);
    } on UnauthorizedException {
      await ref.read(authViewModelProvider.notifier).logout();
      rethrow;
    }
  }

  Future<UsersState> _load({required int pageNumber, required int pageSize}) async {
    final page = await listUsers(pageNumber: pageNumber, pageSize: pageSize);
    final assignments = await getAssignments(pageSize: 300);
    final doctorByPatient = <String, AssignmentInfo>{};
    final countByDoctor = <String, int>{};

    for (final a in assignments) {
      doctorByPatient[a.patient.id] = AssignmentInfo(
        assignmentId: a.assignmentId,
        doctorId: a.doctor.id,
        doctorName: a.doctor.fullName,
      );
      countByDoctor[a.doctor.id] = (countByDoctor[a.doctor.id] ?? 0) + 1;
    }

    return UsersState(
      pageNumber: page.pageNumber,
      pageSize: page.pageSize,
      totalCount: page.totalCount,
      items: page.items,
      doctorByPatientId: doctorByPatient,
      patientsCountByDoctorId: countByDoctor,
    );
  }

  Future<void> refresh() async {
    final current = state.valueOrNull;
    final pn = current?.pageNumber ?? 1;
    final ps = current?.pageSize ?? 50;

    state = const AsyncLoading();
    final next = await AsyncValue.guard(() => _load(pageNumber: pn, pageSize: ps));
    if (next.hasError && next.error is UnauthorizedException) {
      await ref.read(authViewModelProvider.notifier).logout();
      return;
    }

    state = next;
  }

  Future<void> addUser({
    required String email,
    required String password,
    required String firstName,
    required String patronymic,
    required String lastName,
    required String phoneNumber,
    required UserRole role,
  }) async {
    try {
      await createUser(
        email: email,
        password: password,
        patronymic: patronymic,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        role: role,
      );
      await refresh();
    } on UnauthorizedException {
      await ref.read(authViewModelProvider.notifier).logout();
    }
  }

  Future<void> deactivate(String userId) async {
    try {
      await deactivateUser(userId);
      await refresh();
    } on UnauthorizedException {
      await ref.read(authViewModelProvider.notifier).logout();
    }
  }

  Future<void> activate(String userId) async {
    try {
      await activateUser(userId);
      await refresh();
    } on UnauthorizedException {
      await ref.read(authViewModelProvider.notifier).logout();
    }
  }

  Future<void> assignDoctorToPatient({
    required String patientId,
    required String doctorId,
  }) async {
    try {
      await assignDoctor(patientId: patientId, doctorId: doctorId);
      await refresh();
    } on UnauthorizedException {
      await ref.read(authViewModelProvider.notifier).logout();
    }
  }

  Future<void> unassignDoctorFromPatient({
    required String assignmentId,
  }) async {
    try {
      await deleteAssignment(assignmentId);
      await refresh();
    } on UnauthorizedException {
      await ref.read(authViewModelProvider.notifier).logout();
    }
  }
}

final usersViewModelProvider = AsyncNotifierProvider<UsersViewModel, UsersState>(UsersViewModel.new);