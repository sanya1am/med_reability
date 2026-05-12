import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

class PatientProgramEmptyState extends StatelessWidget {
  final String title;
  final String text;
  final bool showSleepIcon;

  const PatientProgramEmptyState({
    super.key,
    required this.title,
    required this.text,
    this.showSleepIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        const SizedBox(height: 42),
        if (showSleepIcon)
          Text(
            'zzz',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: primary,
              fontWeight: FontWeight.w800,
            ),
          )
        else
          Icon(
            Icons.info_outline,
            size: 42,
            color: primary,
          ),
        const SizedBox(height: 14),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colors.textPrimary,
          ),
        ),
      ],
    );
  }
}