import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

class ExercisePrivateAccessSwitch extends StatelessWidget {
  final bool isPrivate;
  final ValueChanged<bool> onChanged;

  const ExercisePrivateAccessSwitch({
    super.key,
    required this.isPrivate,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Switch(
          value: isPrivate,
          onChanged: onChanged,
        ),
        Expanded(
          child: Text(
            'Приватный доступ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}