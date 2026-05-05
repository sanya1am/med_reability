import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';

class PatientOverviewEmptyState extends StatelessWidget {
  final String text;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const PatientOverviewEmptyState({
    super.key,
    required this.text,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      children: [
        const SizedBox(height: 38),
        Icon(
          Icons.info_outline,
          size: 42,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: PrimaryButton(
            text: buttonText,
            onPressed: onButtonPressed,
            height: 38,
            textStyle: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ],
    );
  }
}