import 'package:flutter/material.dart';
import 'package:med_reability/features/patient/presentation/page/patient_well_being_form_page.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_secondary_button.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';

class PatientWorkoutFinishedPage extends StatelessWidget {
  final String planId;
  final int dayNumber;

  const PatientWorkoutFinishedPage({
    super.key,
    required this.planId,
    required this.dayNumber,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 12, 28, 32),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_outlined,
                  size: 72,
                  color: primary,
                ),

                const SizedBox(height: 26),

                Text(
                  'Тренировка завершена',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(height: 8),

                Text(
                  'Вы отлично поработали. Это важный\nшаг в восстановлении.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        text: 'Пропустить',
                        onPressed: () => Navigator.of(context).pop(true),
                        height: 38,
                        textStyle: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PrimaryButton(
                        text: 'Оценить',
                        onPressed: () async {
                          final changed = await Navigator.of(context).push<bool>(
                            MaterialPageRoute(
                              builder: (_) => PatientWellBeingFormPage(
                                planId: planId,
                                dayNumber: dayNumber,
                              ),
                            ),
                          );

                          if (!context.mounted) return;

                          Navigator.of(context).pop(changed == true);
                        },
                        height: 38,
                        textStyle: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}