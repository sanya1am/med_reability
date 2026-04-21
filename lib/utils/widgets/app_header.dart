import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'app_circle_icon_button.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onAction;
  final IconData? actionIcon;
  final Widget? actionIconWidget;

  final double actionBoxSize;
  final double iconSize;

  const AppHeader({
    super.key,
    required this.title,
    this.onAction,
    this.actionIcon,
    this.actionIconWidget,
    this.actionBoxSize = 40,
    this.iconSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    final hasAction =
        onAction != null && (actionIcon != null || actionIconWidget != null);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            if (hasAction)
              AppCircleIconButton(
                size: actionBoxSize,
                onTap: onAction,
                icon: _buildIcon(context),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    final colors = context.appColors;

    if (actionIconWidget != null) {
      return ColorFiltered(
        colorFilter: ColorFilter.mode(
          colors.textPrimary,
          BlendMode.srcIn,
        ),
        child: SizedBox(
          width: iconSize,
          height: iconSize,
          child: Center(child: actionIconWidget!),
        ),
      );
    }

    return Icon(
      actionIcon,
      size: iconSize,
      color: colors.textPrimary,
    );
  }
}