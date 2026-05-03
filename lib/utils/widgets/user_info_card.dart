import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';

class UserInfoCard extends StatelessWidget {
  final String fullName;
  final String email;
  final String phoneNumber;

  final String actionText;
  final VoidCallback? onActionPressed;
  final VoidCallback? onEditPressed;

  final Widget? avatar;

  const UserInfoCard({
    super.key,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.actionText,
    required this.onActionPressed,
    this.onEditPressed,
    this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: isDark
                ? Colors.black.withOpacity(0.18)
                : const Color(0x22000000),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              avatar ??
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: colors.surfaceAlt,
                    child: Icon(
                      Icons.person,
                      size: 44,
                      color: colors.textPrimary,
                    ),
                  ),
              Expanded(
                child: Align(
                  alignment: Alignment.topRight,
                  child: onEditPressed == null
                      ? const SizedBox(width: 24, height: 24)
                      : GestureDetector(
                    onTap: onEditPressed,
                    child: Icon(
                      Icons.edit_outlined,
                      size: 24,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            fullName,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Divider(
            height: 24,
            color: colors.border,
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Почта',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          const SizedBox(height: 2),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              email,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Телефон',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          const SizedBox(height: 2),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              phoneNumber,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 140,
            child: PrimaryButton(
              text: actionText,
              onPressed: onActionPressed,
              height: 38,
              textStyle: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ],
      ),
    );
  }
}