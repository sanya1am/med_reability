import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

class PatientTrainingProgressCard extends StatelessWidget {
  final int percent;

  const PatientTrainingProgressCard({
    super.key,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final primary = Theme.of(context).colorScheme.primary;
    final value = percent.clamp(0, 100);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Прогресс за неделю',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              Text(
                '$value%',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: value / 100,
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