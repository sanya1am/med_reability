import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

class RehabilitationTemplateTile extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const RehabilitationTemplateTile({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: selected ? colors.background : colors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, 4),
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.12)
                  : const Color(0x11000000),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            GestureDetector(
              onTap: onDelete,
              behavior: HitTestBehavior.opaque,
              child: Icon(
                Icons.close,
                size: 18,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}