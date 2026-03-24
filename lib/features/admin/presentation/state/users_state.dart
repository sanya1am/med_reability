import 'package:med_reability/features/admin/domain/entities/clinic_user.dart';
import 'package:med_reability/features/auth/domain/entities/role.dart';

class UsersState {
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final List<ClinicUser> items;
  final Map<String, AssignmentInfo> doctorByPatientId;
  final Map<String, int> patientsCountByDoctorId;

  const UsersState({
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.items,
    required this.doctorByPatientId,
    required this.patientsCountByDoctorId,
  });

  List<ClinicUser> get doctors => items.where((u) => u.role == UserRole.doctor).toList();
  List<ClinicUser> get patients => items.where((u) => u.role == UserRole.patient).toList();
}


class AssignmentInfo {
  final String assignmentId;
  final String doctorId;
  final String doctorName;

  const AssignmentInfo({
    required this.assignmentId,
    required this.doctorId,
    required this.doctorName,
  });
}