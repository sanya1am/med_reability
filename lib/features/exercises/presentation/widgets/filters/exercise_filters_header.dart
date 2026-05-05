import 'package:flutter/material.dart';

class ExerciseFiltersHeader extends StatelessWidget {
  final VoidCallback onReset;

  const ExerciseFiltersHeader({
    super.key,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Фильтры',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        GestureDetector(
          onTap: onReset,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 6,
            ),
            child: Text(
              'Сбросить',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}