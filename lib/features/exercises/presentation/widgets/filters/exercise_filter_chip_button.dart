import 'package:flutter/material.dart';

class ExerciseFilterChipButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const ExerciseFilterChipButton({
    super.key,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: selected ? primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: primary,
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: selected ? Colors.white : primary,
          ),
        ),
      ),
    );
  }
}