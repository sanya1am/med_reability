import 'package:flutter/material.dart';
import '../../../../features/auth/domain/entities/role.dart';
import '../../../../utils/widgets/app_dropdown_field.dart';

class UserRoleDropdown extends StatelessWidget {
  final UserRole value;
  final ValueChanged<UserRole?> onChanged;

  const UserRoleDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppDropdownField<UserRole>(
      value: value,
      hintText: 'Выберите роль',
      onChanged: onChanged,
      items: const [
        DropdownMenuItem(
          value: UserRole.doctor,
          child: Text('Инструктор'),
        ),
        DropdownMenuItem(
          value: UserRole.patient,
          child: Text('Пациент'),
        ),
      ],
    );
  }
}