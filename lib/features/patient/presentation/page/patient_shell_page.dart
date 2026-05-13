import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reability/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:med_reability/utils/assets/app_assets.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_bottom_nav.dart';
import 'package:med_reability/utils/widgets/app_header.dart';
import 'package:med_reability/utils/widgets/app_secondary_button.dart';
import 'package:med_reability/utils/widgets/app_side_nav.dart';

class PatientShellPage extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  final String location;

  const PatientShellPage({
    super.key,
    required this.navigationShell,
    required this.location,
  });

  bool get _showMobileNav {
    return location == '/patient/trainings' || location == '/patient/home';
  }

  String get _title {
    return switch (navigationShell.currentIndex) {
      0 => 'Тренировки',
      1 => 'Главная',
      2 => 'Уведомления',
      _ => 'Главная',
    };
  }

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        if (isDesktop) {
          return _PatientDesktopShell(
            navigationShell: navigationShell,
            onNavTap: _goBranch,
            onLogout: () {
              ref.read(authViewModelProvider.notifier).logout();
            },
          );
        }

        return _PatientMobileShell(
          navigationShell: navigationShell,
          title: _title,
          showMobileNav: _showMobileNav,
          onNavTap: _goBranch,
        );
      },
    );
  }
}

class _PatientDesktopShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final ValueChanged<int> onNavTap;
  final VoidCallback onLogout;

  const _PatientDesktopShell({
    required this.navigationShell,
    required this.onNavTap,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      body: Row(
        children: [
          AppSideNav(
            title: 'MedRehab',
            index: navigationShell.currentIndex,
            onTap: onNavTap,
            items: [
              SideNavItem(
                icon: SvgPicture.asset(AppAssets.heartIcon),
                label: 'Тренировки',
              ),
              SideNavItem(
                icon: SvgPicture.asset(AppAssets.homeIcon),
                label: 'Главная',
              ),
              SideNavItem(
                icon: SvgPicture.asset(AppAssets.notificationsIcon),
                label: 'Уведомления',
              ),
            ],
            footer: SecondaryButton(
              text: 'Выйти',
              onPressed: onLogout,
              height: 30,
              textStyle: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Expanded(
            child: Container(
              color: colors.background,
              child: navigationShell,
            ),
          ),
        ],
      ),
    );
  }
}

class _PatientMobileShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final String title;
  final bool showMobileNav;
  final ValueChanged<int> onNavTap;

  const _PatientMobileShell({
    required this.navigationShell,
    required this.title,
    required this.showMobileNav,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              if (showMobileNav)
                AppHeader(
                  title: title,
                  actionIconWidget: SvgPicture.asset(
                    AppAssets.notificationsIcon,
                  ),
                  onAction: () => onNavTap(2),
                ),
              Expanded(
                child: navigationShell,
              ),
            ],
          ),

          if (showMobileNav)
            Positioned(
              left: 0,
              right: 0,
              bottom: 24,
              child: SafeArea(
                top: false,
                child: Center(
                  child: AppBottomNav(
                    index: navigationShell.currentIndex.clamp(0, 1),
                    onTap: onNavTap,
                    items: [
                      BottomNavItem(
                        icon: SvgPicture.asset(AppAssets.heartIcon),
                      ),
                      BottomNavItem(
                        icon: SvgPicture.asset(AppAssets.homeIcon),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}