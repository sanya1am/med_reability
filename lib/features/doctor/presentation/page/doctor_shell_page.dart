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

class DoctorShellPage extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  final String location;

  const DoctorShellPage({
    super.key,
    required this.navigationShell,
    required this.location,
  });

  bool get _isRootLocation {
    return location == '/doctor/patients' ||
        location == '/doctor/exercises' ||
        location == '/doctor/home';
        // || location == '/doctor/notifications';
  }

  String get _title {
    return switch (navigationShell.currentIndex) {
      0 => 'Пациенты',
      1 => 'Упражнения',
      2 => 'Главная',
      // 3 => 'Уведомления',
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
          return _DoctorDesktopShell(
            navigationShell: navigationShell,
            onNavTap: _goBranch,
            onLogout: () {
              ref.read(authViewModelProvider.notifier).logout();
            },
          );
        }

        return _DoctorMobileShell(
          navigationShell: navigationShell,
          title: _title,
          showMobileNav: _isRootLocation,
          onNavTap: _goBranch,
        );
      },
    );
  }
}

class _DoctorDesktopShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final ValueChanged<int> onNavTap;
  final VoidCallback onLogout;

  const _DoctorDesktopShell({
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
                label: 'Пациенты',
              ),
              SideNavItem(
                icon: SvgPicture.asset(AppAssets.listIcon),
                label: 'Упражнения',
              ),
              SideNavItem(
                icon: SvgPicture.asset(AppAssets.homeIcon),
                label: 'Главная',
              ),
              // SideNavItem(
              //   icon: SvgPicture.asset(AppAssets.notificationsIcon),
              //   label: 'Уведомления',
              // ),
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

class _DoctorMobileShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final String title;
  final bool showMobileNav;
  final ValueChanged<int> onNavTap;

  const _DoctorMobileShell({
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
                  // actionIconWidget: SvgPicture.asset(
                  //   AppAssets.notificationsIcon,
                  // ),
                  // onAction: () {},
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
                    index: navigationShell.currentIndex.clamp(0, 2),
                    onTap: onNavTap,
                    items: [
                      BottomNavItem(
                        icon: SvgPicture.asset(AppAssets.listIcon),
                      ),
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