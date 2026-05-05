import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

class PatientWeekProgressCard extends StatelessWidget {
  final int percent;

  const PatientWeekProgressCard({
    super.key,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final primary = Theme.of(context).colorScheme.primary;

    final normalizedPercent = percent.clamp(0, 100);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Прогресс за неделю',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 18,
                  ),
                ),
              ),
              Text(
                '$normalizedPercent%',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: normalizedPercent / 100,
              minHeight: 8,
              backgroundColor: colors.background,
              valueColor: AlwaysStoppedAnimation<Color>(primary),
            ),
          ),
        ],
      ),
    );
  }
}