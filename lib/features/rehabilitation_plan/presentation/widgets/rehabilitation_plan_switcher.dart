import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

class RehabilitationPlanSwitcher extends StatelessWidget {
  final String title;
  final bool canGoPrevious;
  final bool canGoNext;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const RehabilitationPlanSwitcher({
    super.key,
    required this.title,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _SwitcherButton(
            icon: Icons.chevron_left,
            enabled: canGoPrevious,
            onTap: onPrevious,
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          _SwitcherButton(
            icon: Icons.chevron_right,
            enabled: canGoNext,
            onTap: onNext,
          ),
        ],
      ),
    );
  }
}

class _SwitcherButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _SwitcherButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 42,
        height: 36,
        child: Icon(
          icon,
          size: 22,
          color: enabled ? colors.textPrimary : colors.hint,
        ),
      ),
    );
  }
}