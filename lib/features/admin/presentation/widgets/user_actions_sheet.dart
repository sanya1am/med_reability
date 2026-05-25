import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/features/admin/domain/entities/clinic_user.dart';
import 'package:med_reability/features/admin/presentation/state/users_state.dart';
import 'package:med_reability/features/admin/presentation/view_model/users_view_model.dart';
import 'package:med_reability/features/admin/presentation/widgets/doctor_picker_sheet.dart';
import 'package:med_reability/features/auth/domain/entities/role.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

enum _UserAction {
  edit,
  assignDoctor,
  unassignDoctor,
  activate,
  deactivate,
}

class UserActionsPopupMenu extends ConsumerWidget {
  final ClinicUser user;
  final AssignmentInfo? patientAssignment;
  final int doctorPatientsCount;

  const UserActionsPopupMenu({
    super.key,
    required this.user,
    required this.patientAssignment,
    required this.doctorPatientsCount,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;

    final isPatient = user.role == UserRole.patient;
    final isDoctor = user.role == UserRole.doctor;

    final hasAssignments = isPatient
        ? patientAssignment != null
        : isDoctor
        ? doctorPatientsCount > 0
        : false;

    final deactivateBlocked = user.isActive && hasAssignments;
    final canDeactivate = user.isActive && !hasAssignments;

    return PopupMenuButton<_UserAction>(
      tooltip: 'Действия',
      icon: Icon(
        Icons.more_horiz,
        size: 22,
        color: colors.textPrimary,
      ),
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      position: PopupMenuPosition.under,
      onSelected: (action) async {
        final vm = ref.read(usersViewModelProvider.notifier);

        switch (action) {
          case _UserAction.edit:
          // Пока действие не реализовано.
            return;

          case _UserAction.assignDoctor:
            await _assignDoctor(
              context: context,
              vm: vm,
            );
            return;

          case _UserAction.unassignDoctor:
            await _unassignDoctor(
              context: context,
              vm: vm,
            );
            return;

          case _UserAction.activate:
            await _runAction(
              context: context,
              action: () => vm.activate(user.id),
              successMessage: 'Пользователь активирован',
            );
            return;

          case _UserAction.deactivate:
            await _runAction(
              context: context,
              action: () => vm.deactivate(user.id),
              successMessage: 'Пользователь деактивирован',
            );
            return;
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem<_UserAction>(
            value: _UserAction.edit,
            enabled: false,
            child: _MenuText(
              text: 'Редактировать данные',
              enabled: false,
            ),
          ),

          if (isPatient)
            PopupMenuItem<_UserAction>(
              value: patientAssignment == null
                  ? _UserAction.assignDoctor
                  : _UserAction.unassignDoctor,
              child: _MenuText(
                text: patientAssignment == null
                    ? 'Назначить инструктора'
                    : 'Снять с назначения',
              ),
            ),

          PopupMenuItem<_UserAction>(
            value: user.isActive
                ? _UserAction.deactivate
                : _UserAction.activate,
            enabled: user.isActive ? canDeactivate : true,
            child: _MenuText(
              text: user.isActive ? 'Деактивировать' : 'Активировать',
              enabled: user.isActive ? canDeactivate : true,
              subtitle: deactivateBlocked
                  ? 'Нельзя деактивировать, пока есть назначения'
                  : null,
            ),
          ),
        ];
      },
    );
  }

  Future<void> _assignDoctor({
    required BuildContext context,
    required UsersViewModel vm,
  }) async {
    final doctor = await showDoctorPickerDialog(
      context: context,
    );

    if (doctor == null) return;

    if (!context.mounted) return;

    await _runAction(
      context: context,
      action: () => vm.assignDoctorToPatient(
        patientId: user.id,
        doctorId: doctor.id,
      ),
      successMessage: 'Инструктор назначен',
    );
  }

  Future<void> _unassignDoctor({
    required BuildContext context,
    required UsersViewModel vm,
  }) async {
    final assignment = patientAssignment;
    if (assignment == null) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final colors = dialogContext.appColors;

        return AlertDialog(
          title: Text(
            'Снять назначение',
            style: Theme.of(dialogContext).textTheme.titleSmall?.copyWith(
              color: colors.textPrimary,
            ),
          ),
          content: Text(
            'Убрать связь инструктора с пациентом?',
            style: Theme.of(dialogContext).textTheme.bodyMedium?.copyWith(
              color: colors.textPrimary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Снять'),
            ),
          ],
        );
      },
    );

    if (ok != true) return;

    if (!context.mounted) return;

    await _runAction(
      context: context,
      action: () => vm.unassignDoctorFromPatient(
        assignmentId: assignment.assignmentId,
      ),
      successMessage: 'Назначение снято',
    );
  }

  Future<void> _runAction({
    required BuildContext context,
    required Future<void> Function() action,
    required String successMessage,
  }) async {
    try {
      await action();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMessage),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}

class _MenuText extends StatelessWidget {
  final String text;
  final String? subtitle;
  final bool enabled;

  const _MenuText({
    required this.text,
    this.subtitle,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final titleColor = enabled ? colors.textPrimary : colors.textSecondary;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 210,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 15,
              color: titleColor,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}