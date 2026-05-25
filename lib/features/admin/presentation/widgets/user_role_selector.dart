import 'package:flutter/material.dart';
import 'package:med_reability/features/auth/domain/entities/role.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

class UserRoleSelector extends StatelessWidget {
  final UserRole value;
  final ValueChanged<UserRole> onChanged;

  const UserRoleSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  bool get _isDoctor => value == UserRole.doctor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / 2;

          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                left: _isDoctor ? 4 : itemWidth,
                top: 4,
                bottom: 4,
                width: itemWidth - 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.background,
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
              ),

              Row(
                children: [
                  _RoleSegmentItem(
                    text: 'Инструктор',
                    selected: value == UserRole.doctor,
                    onTap: () => onChanged(UserRole.doctor),
                  ),
                  _RoleSegmentItem(
                    text: 'Пациент',
                    selected: value == UserRole.patient,
                    onTap: () => onChanged(UserRole.patient),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RoleSegmentItem extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _RoleSegmentItem({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: colors.textPrimary,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}