import 'package:flutter/material.dart';

class BottomNavItem {
  final IconData icon;
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
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: const [
              BoxShadow(
                blurRadius: 18,
                offset: Offset(0, 8),
                color: Color(0x22000000),
              )
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(items.length, (i) {
              final selected = i == index;
              return Padding(
                padding: EdgeInsets.only(right: i == items.length - 1 ? 0 : 10),
                child: GestureDetector(
                  onTap: () => onTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: selected ? Colors.black : const Color(0xFFEFEFEF),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Icon(
                      items[i].icon,
                      color: selected ? Colors.white : Colors.black,
                      size: 24,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}