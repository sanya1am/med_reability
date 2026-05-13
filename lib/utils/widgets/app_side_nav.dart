import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

class SideNavItem {
  final Widget icon;
  final String label;

  const SideNavItem({
    required this.icon,
    required this.label,
  });
}

class AppSideNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  final List<SideNavItem> items;
  final Widget? footer;
  final String title;

  const AppSideNav({
    super.key,
    required this.index,
    required this.onTap,
    required this.items,
    required this.title,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: 235,
      color: colors.surface,
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SideNavLogo(title: title),

          const SizedBox(height: 28),

          ...List.generate(items.length, (i) {
            return _SideNavButton(
              item: items[i],
              selected: i == index,
              onTap: () => onTap(i),
            );
          }),

          const Spacer(),

          if (footer != null) footer!,
        ],
      ),
    );
  }
}

class _SideNavLogo extends StatelessWidget {
  final String title;

  const _SideNavLogo({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            Icons.add,
            size: 18,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SideNavButton extends StatelessWidget {
  final SideNavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _SideNavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final primary = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: selected ? primary : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Row(
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  selected ? Colors.white : colors.textPrimary,
                  BlendMode.srcIn,
                ),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: item.icon,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                item.label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: selected ? Colors.white : colors.textPrimary,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}