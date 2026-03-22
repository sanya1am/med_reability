import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onAction;
  final IconData actionIcon;

  const AppHeader({
    super.key,
    required this.title,
    this.onAction,
    this.actionIcon = Icons.add,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 12),
        child: Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium
            ),
            const Spacer(),
            if (onAction != null)
              GestureDetector(
                onTap: onAction,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFEFEFEF),
                  ),
                  child: Icon(actionIcon, size: 26),
                ),
              ),
          ],
        ),
      ),
    );
  }
}