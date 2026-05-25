import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reability/core/router/app_route_names.dart';
import 'package:med_reability/features/admin/presentation/view_model/users_view_model.dart';
import 'package:med_reability/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:med_reability/utils/assets/app_assets.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_bottom_nav.dart';
import 'package:med_reability/utils/widgets/app_header.dart';
import 'package:med_reability/utils/widgets/app_secondary_button.dart';
import 'package:med_reability/utils/widgets/app_side_nav.dart';

class AdminShellPage extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;
  final String location;

  const AdminShellPage({
    super.key,
    required this.navigationShell,
    required this.location,
  });

  @override
  ConsumerState<AdminShellPage> createState() => _AdminShellPageState();
}

class _AdminShellPageState extends ConsumerState<AdminShellPage> {
  @override
  void initState() {
    super.initState();
  }

  bool get _showMobileNav {
    return widget.location == '/admin/doctors' ||
        widget.location == '/admin/patients' ||
        widget.location == '/admin/home';
  }

  String get _title {
    return switch (widget.navigationShell.currentIndex) {
      0 => 'Инструкторы ЛФК',
      1 => 'Пациенты',
      2 => 'Главная',
      _ => 'Главная',
    };
  }

  bool get _canCreateUser {
    return widget.navigationShell.currentIndex == 0 ||
        widget.navigationShell.currentIndex == 1;
  }

  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  Future<void> _openCreate() async {
    final routeName = switch (widget.navigationShell.currentIndex) {
      0 => AppRouteNames.adminDoctorsUserForm,
      1 => AppRouteNames.adminPatientsUserForm,
      _ => null,
    };

    if (routeName == null) return;

    final created = await context.pushNamed<bool>(routeName);

    if (created == true && mounted) {
      await ref.read(usersViewModelProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        if (isDesktop) {
          return _AdminDesktopShell(
            navigationShell: widget.navigationShell,
            onNavTap: _goBranch,
            onLogout: () {
              ref.read(authViewModelProvider.notifier).logout();
            },
          );
        }

        return _AdminMobileShell(
          navigationShell: widget.navigationShell,
          title: _title,
          showMobileNav: _showMobileNav,
          canCreateUser: _canCreateUser,
          onCreate: _openCreate,
          onNavTap: _goBranch,
        );
      },
    );
  }
}

class _AdminDesktopShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final ValueChanged<int> onNavTap;
  final VoidCallback onLogout;

  const _AdminDesktopShell({
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
                icon: SvgPicture.asset(AppAssets.doctorsIcon),
                label: 'Инструкторы',
              ),
              SideNavItem(
                icon: SvgPicture.asset(AppAssets.heartIcon),
                label: 'Пациенты',
              ),
              SideNavItem(
                icon: SvgPicture.asset(AppAssets.homeIcon),
                label: 'Главная',
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

class _AdminMobileShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final String title;
  final bool showMobileNav;
  final bool canCreateUser;
  final VoidCallback onCreate;
  final ValueChanged<int> onNavTap;

  const _AdminMobileShell({
    required this.navigationShell,
    required this.title,
    required this.showMobileNav,
    required this.canCreateUser,
    required this.onCreate,
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
                  actionIcon: canCreateUser ? Icons.add : null,
                  onAction: canCreateUser ? onCreate : null,
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
                        icon: SvgPicture.asset(AppAssets.doctorsIcon),
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