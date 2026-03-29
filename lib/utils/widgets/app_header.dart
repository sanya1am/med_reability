import 'package:flutter/material.dart';

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
    this.actionBoxSize = 46,
    this.iconSize = 22,
  });

  @override
  Widget build(BuildContext context) {
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
            // const Spacer(),

            SizedBox(
              width: actionBoxSize,
              height: actionBoxSize,
              child: (onAction != null && (actionIcon != null || actionIconWidget != null))
                  ? GestureDetector(
                onTap: onAction,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFEFEFEF),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: _buildIcon(),
                  ),
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    if (actionIconWidget != null) {
      return ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
        child: SizedBox(
          width: iconSize,
          height: iconSize,
          child: FittedBox(
            fit: BoxFit.contain,
            child: actionIconWidget!,
          ),
        ),
      );
    }

    return Icon(actionIcon, size: iconSize, color: Colors.black);
  }
}