import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/features/admin/presentation/state/users_state.dart';
import '../../../auth/domain/entities/role.dart';
import '../../domain/entities/clinic_user.dart';
import '../view_model/users_view_model.dart';
import 'doctor_picker_sheet.dart';

Future<void> showUserActionsSheet({
  required BuildContext context,
  required WidgetRef ref,
  required ClinicUser user,
  required AssignmentInfo? patientAssignment,
  required int doctorPatientsCount,
}) async {
  final vm = ref.read(usersViewModelProvider.notifier);

  final isPatient = user.role == UserRole.patient;
  final isDoctor = user.role == UserRole.doctor;

  final hasAssignments = isPatient
      ? patientAssignment != null
      : isDoctor
      ? doctorPatientsCount > 0
      : false;

  final deactivateBlocked = user.isActive && hasAssignments;
  final canDeactivate = user.isActive && !hasAssignments;

  await showModalBottomSheet(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (_) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              ListTile(
                enabled: false,
                title: Text('Редактировать данные', style: TextStyle(fontSize: 18)),
              ),

              if (isPatient)
                ListTile(
                  title: Text(
                    patientAssignment == null ? 'Назначить врача' : 'Снять с назначения',
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () async {
                    Navigator.pop(context);

                    if (patientAssignment == null) {
                      final doctor = await showModalBottomSheet<ClinicUser>(
                        context: context,
                        isScrollControlled: true,
                        showDragHandle: true,
                        builder: (_) => const DoctorPickerSheet(),
                      );

                      if (doctor != null) {
                        await vm.assignDoctorToPatient(patientId: user.id, doctorId: doctor.id);
                      }
                      return;
                    }

                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Снять назначение', style: TextStyle(fontSize: 18)),
                        content: Text('Убрать связь врача с пациентом?', style: TextStyle(fontSize: 18)),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Отмена')),
                          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Снять')),
                        ],
                      ),
                    );

                    if (ok == true) {
                      await vm.unassignDoctorFromPatient(assignmentId: patientAssignment!.assignmentId);
                    }
                  },
                ),

              ListTile(
                title: Text(
                  user.isActive ? 'Деактивировать' : 'Активировать',
                  style: TextStyle(fontSize: 18),
                ),
                subtitle: deactivateBlocked ? Text(
                  'Нельзя деактивировать, пока есть назначения',
                  style: TextStyle(fontSize: 16),
                ) : null,
                enabled: user.isActive ? canDeactivate : true,
                onTap: () async {
                  Navigator.pop(context);
                  if (user.isActive) {
                    if (canDeactivate) await vm.deactivate(user.id);
                  } else {
                    await vm.activate(user.id);
                  }
                }
              ),
            ],
          ),
        ),
      );
    },
  );
}