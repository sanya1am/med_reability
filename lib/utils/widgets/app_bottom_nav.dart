import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

class BottomNavItem {
  final Widget icon;
  const BottomNavItem({required this.icon});
}

class AppBottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  final List<BottomNavItem> items;

  const AppBottomNav({
    super.key,
    required this.index,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colors.navBackground,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 8),
              color: isDark
                  ? Colors.black.withOpacity(0.22)
                  : const Color(0x22000000),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(items.length, (i) {
            final selected = i == index;

            return Padding(
              padding: EdgeInsets.only(
                right: i == items.length - 1 ? 0 : 10,
              ),
              child: GestureDetector(
                onTap: () => onTap(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: selected ? appPrimaryBlue : Colors.transparent,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Center(
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        selected ? Colors.white : colors.navInactiveIcon,
                        BlendMode.srcIn,
                      ),
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: items[i].icon,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}