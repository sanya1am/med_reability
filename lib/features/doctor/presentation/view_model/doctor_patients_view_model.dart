import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/errors/unauthorized_exception.dart';
import '../../../auth/presentation/view_model/auth_view_model.dart';
import '../state/doctor_patients_state.dart';


class DoctorPatientsViewModel extends AsyncNotifier<DoctorPatientsState> {
  late final getMyPatients = ref.read(getMyPatientsUseCaseProvider);

  @override
  Future<DoctorPatientsState> build() async {
    try {
      final list = await getMyPatients();
      return DoctorPatientsState(patients: list);
    } on UnauthorizedException {
      await ref.read(authViewModelProvider.notifier).logout();
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final next = await AsyncValue.guard(() async {
      final list = await getMyPatients();
      return DoctorPatientsState(patients: list);
    });

    if (next.hasError && next.error is UnauthorizedException) {
      await ref.read(authViewModelProvider.notifier).logout();
      return;
    }

    state = next;
  }
}

final doctorPatientsViewModelProvider =
AsyncNotifierProvider<DoctorPatientsViewModel, DoctorPatientsState>(DoctorPatientsViewModel.new);