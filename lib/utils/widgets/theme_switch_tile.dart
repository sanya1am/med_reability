import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import '../../core/di/providers.dart';


class ThemeSwitchTile extends ConsumerWidget {
  const ThemeSwitchTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final themeMode = ref.watch(themeModeProvider);
    final platformBrightness = MediaQuery.platformBrightnessOf(context);

    final isDark = switch (themeMode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system => platformBrightness == Brightness.dark,
    };

    return Container(
      height: 46,
      padding: const EdgeInsets.only(left: 16, right: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Темная тема',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
          Transform.scale(
            scale: 0.72,
            child: Switch(
              value: isDark,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).toggleDark(value);
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              splashRadius: 0,
              activeColor: Colors.white,
              activeTrackColor: appPrimaryBlue,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFFD1D1D1),
              trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
              trackOutlineWidth: MaterialStateProperty.all(0),
            ),
          ),
        ],
      ),
    );
  }
}