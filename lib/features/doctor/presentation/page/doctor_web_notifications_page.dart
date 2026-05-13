import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

class DoctorWebNotificationsPage extends StatelessWidget {
  const DoctorWebNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Center(
      child: Text(
        'Уведомления пока не реализованы',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: colors.textSecondary,
        ),
      ),
    );
  }
}