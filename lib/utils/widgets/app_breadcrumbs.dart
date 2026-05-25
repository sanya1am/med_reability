import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

class AppBreadcrumbItem {
  final String label;
  final VoidCallback? onTap;

  const AppBreadcrumbItem({
    required this.label,
    this.onTap,
  });
}

class AppBreadcrumbs extends StatelessWidget {
  final List<AppBreadcrumbItem> items;
  final VoidCallback onBack;

  const AppBreadcrumbs({
    super.key,
    required this.items,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      children: [
        GestureDetector(
          onTap: onBack,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: colors.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chevron_left,
              color: colors.textPrimary,
              size: 24,
            ),
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: List.generate(items.length * 2 - 1, (index) {
              if (index.isOdd) {
                return Text(
                  '•',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                  ),
                );
              }

              final item = items[index ~/ 2];
              final isLast = index ~/ 2 == items.length - 1;

              return GestureDetector(
                onTap: isLast ? null : item.onTap,
                behavior: HitTestBehavior.opaque,
                child: Text(
                  item.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isLast
                        ? colors.textPrimary
                        : colors.textSecondary,
                    fontWeight: isLast ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}