import 'package:med_reability/features/admin/domain/entities/clinic_user.dart';
import 'package:med_reability/features/auth/domain/entities/role.dart';

class UsersState {
  final int pageNumber;
  final int pageSize;
  final int totalCount;
  final List<ClinicUser> items;

  const UsersState({
    required this.pageNumber,
    required this.pageSize,
    required this.totalCount,
    required this.items,
  });

  List<ClinicUser> get doctors => items.where((u) => u.role == UserRole.doctor).toList();
  List<ClinicUser> get patients => items.where((u) => u.role == UserRole.patient).toList();
}