import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/features/admin/domain/entities/clinic_user.dart';
import 'package:med_reability/features/admin/presentation/state/users_state.dart';
import 'package:med_reability/features/admin/presentation/widgets/user_actions_sheet.dart';
import 'package:med_reability/features/auth/domain/entities/role.dart';

enum UsersTab { doctors, patients }

class UsersList extends ConsumerWidget {
  final List users;
  final UsersState state;
  final UsersTab tab;

  const UsersList({
    required this.users,
    required this.state,
    required this.tab,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (users.isEmpty) return const Center(child: Text('Пусто'));

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      itemCount: users.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final u = users[i] as ClinicUser;

        final assignment = state.doctorByPatientId[u.id];
        final patientsCount = state.patientsCountByDoctorId[u.id] ?? 0;

        String subtitle = u.email;
        if (tab == UsersTab.patients) {
          subtitle = assignment == null ? 'Врач: не назначен' : 'Врач: ${assignment.doctorName}';
        } else if (tab == UsersTab.doctors && patientsCount > 0) {
          subtitle = 'Пациентов: $patientsCount';
        }

        final hasAssignments = tab == UsersTab.patients
            ? assignment != null
            : (tab == UsersTab.doctors ? patientsCount > 0 : false);

        final canDeactivate = u.isActive && !hasAssignments;

        return GestureDetector(
          onTap: () => showUserActionsSheet(
            context: context,
            ref: ref,
            user: u,
            patientAssignment: u.role == UserRole.patient ? assignment : null,
            doctorPatientsCount: u.role == UserRole.doctor ? patientsCount : 0,
          ),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(u.fullName, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                Text(
                  u.isActive ? 'Активен' : 'Неактивен',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: u.isActive ? Colors.black : const Color(0xFF9A9A9A),
                  ),
                ),

                const SizedBox(width: 10),

                const SizedBox(width: 6),
                const Icon(Icons.more_horiz, size: 22),
              ],
            ),
          ),
        );
      },
    );
  }
}