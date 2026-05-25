import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/validation/password_validator.dart';

class PasswordRequirementsText extends StatelessWidget {
  final String password;

  const PasswordRequirementsText({
    super.key,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) {
      return const SizedBox.shrink();
    }

    final result = PasswordValidator.validate(password);

    if (result.isValid) {
      return const SizedBox.shrink();
    }

    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        result.errorText,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: colors.textSecondary,
        ),
      ),
    );
  }
}