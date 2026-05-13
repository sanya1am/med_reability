import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/features/admin/domain/entities/clinic_user.dart';
import 'package:med_reability/features/admin/presentation/state/users_state.dart';
import 'package:med_reability/features/admin/presentation/widgets/user_actions_sheet.dart';
import 'package:med_reability/features/auth/domain/entities/role.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

enum UsersTab { doctors, patients }

class UsersList extends ConsumerWidget {
  final List<ClinicUser> users;
  final UsersState state;
  final UsersTab tab;
  final EdgeInsetsGeometry padding;

  const UsersList({
    super.key,
    required this.users,
    required this.state,
    required this.tab,
    this.padding = const EdgeInsets.fromLTRB(28, 16, 28, 120),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;

    if (users.isEmpty) {
      return Center(
        child: Text(
          'Пусто',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colors.textPrimary,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: padding,
      itemCount: users.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, i) {
        final u = users[i];

        final assignment = state.doctorByPatientId[u.id];
        final patientsCount = state.patientsCountByDoctorId[u.id] ?? 0;

        String subtitle = u.email;

        if (tab == UsersTab.patients) {
          subtitle = assignment == null
              ? 'Инструктор: не назначен'
              : 'Инструктор: ${assignment.doctorName}';
        } else if (tab == UsersTab.doctors && patientsCount > 0) {
          subtitle = 'Пациентов: $patientsCount';
        }

        return GestureDetector(
          onTap: () => showUserActionsSheet(
            context: context,
            ref: ref,
            user: u,
            patientAssignment: u.role == UserRole.patient ? assignment : null,
            doctorPatientsCount: u.role == UserRole.doctor ? patientsCount : 0,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.18)
                      : const Color(0x22000000),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        u.fullName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  u.isActive ? 'Активен' : 'Неактивен',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: u.isActive
                        ? colors.textPrimary
                        : colors.textSecondary,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  Icons.more_horiz,
                  size: 22,
                  color: colors.textPrimary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}