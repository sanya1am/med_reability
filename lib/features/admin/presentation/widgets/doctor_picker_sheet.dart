import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:med_reability/features/admin/domain/entities/clinic_user.dart';
import 'package:med_reability/features/admin/presentation/view_model/users_view_model.dart';
import 'package:med_reability/utils/assets/app_assets.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import '../../../../utils/widgets/app_text_field.dart';

Future<ClinicUser?> showDoctorPickerDialog({
  required BuildContext context,
}) {
  return showDialog<ClinicUser>(
    context: context,
    barrierColor: Colors.black.withOpacity(0.12),
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5,
          sigmaY: 5,
        ),
        child: const _DoctorPickerDialog(),
      );
    },
  );
}

class _DoctorPickerDialog extends ConsumerStatefulWidget {
  const _DoctorPickerDialog();

  @override
  ConsumerState<_DoctorPickerDialog> createState() =>
      _DoctorPickerDialogState();
}

class _DoctorPickerDialogState extends ConsumerState<_DoctorPickerDialog> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(usersViewModelProvider).valueOrNull;
    final doctors = data?.doctors ?? const <ClinicUser>[];
    final colors = context.appColors;

    final q = _search.text.trim().toLowerCase();

    final filtered = q.isEmpty
        ? doctors
        : doctors.where((doctor) {
      final value = '${doctor.fullName} ${doctor.email}'.toLowerCase();
      return value.contains(q);
    }).toList();

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 24,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 520,
          maxHeight: MediaQuery.sizeOf(context).height - 80,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
          decoration: BoxDecoration(
            color: colors.dialogBackground,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 24,
                offset: const Offset(0, 8),
                color: colors.dialogShadow,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Выбрать инструктора',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 22),

              AppTextField(
                hintText: 'Поиск инструктора',
                controller: _search,
                prefixIcon: SvgPicture.asset(
                  AppAssets.searchIcon,
                  fit: BoxFit.scaleDown,
                  colorFilter: ColorFilter.mode(
                    colors.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 16),

              if (filtered.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 34),
                  child: Text(
                    'Инструкторы не найдены',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final doctor = filtered[index];

                      return _DoctorPickerTile(
                        doctor: doctor,
                        onTap: () => Navigator.of(context).pop(doctor),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DoctorPickerTile extends StatelessWidget {
  final ClinicUser doctor;
  final VoidCallback onTap;

  const _DoctorPickerTile({
    required this.doctor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.fullName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 17,
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctor.email,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              Icon(
                Icons.chevron_right,
                size: 22,
                color: colors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}