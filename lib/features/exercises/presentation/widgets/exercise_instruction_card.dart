import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:med_reability/features/exercises/presentation/widgets/exercise_step_number.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

class ExerciseInstructionCard extends StatelessWidget {
  final int number;
  final String text;

  const ExerciseInstructionCard({
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withOpacity(0.18)
                : const Color(0x22000000),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 2),
          ExerciseStepNumberBadge(
            number: number,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}