import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:med_reability/features/admin/presentation/page/admin_profile_page.dart';
import 'package:med_reability/features/admin/presentation/page/user_create_page.dart';
import 'package:med_reability/features/admin/presentation/view_model/users_view_model.dart';
import 'package:med_reability/features/admin/presentation/widgets/users_list.dart';
import 'package:med_reability/utils/assets/app_assets.dart';
import '../../../../utils/widgets/app_header.dart';
import '../../../../utils/widgets/app_bottom_nav.dart';


class AdminHomePage extends ConsumerStatefulWidget {
  const AdminHomePage({super.key});

  @override
  ConsumerState<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends ConsumerState<AdminHomePage> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(usersViewModelProvider.notifier).refresh();
    });
  }

  Future<void> _openCreate() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const UserCreatePage()),
    );
    if (created == true) {
      await ref.read(usersViewModelProvider.notifier).refresh();
    }
  }

  void _onBottomNav(int i) {
    if (_index == i) return;
    setState(() => _index = i);
    if (i == 0 || i == 1) {
      ref.read(usersViewModelProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(usersViewModelProvider);
    final vm = ref.read(usersViewModelProvider.notifier);
    final headerTitle = switch (_index) {
      0 => 'Врачи',
      1 => 'Пациенты',
      _ => 'Профиль',
    };

    return Scaffold(
      body: Column(
        children: [
          AppHeader(
            title: headerTitle,
            actionIcon: Icons.add,
            onAction: (_index == 2) ? null : _openCreate,
          ),

          Expanded(
            child: (_index == 2)
                ? const AdminProfilePage()
                : data.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Ошибка: $e')),
              data: (s) => IndexedStack(
                index: _index,
                children: [
                  UsersList(
                    users: s.doctors,
                    state: s,
                    tab: UsersTab.doctors,
                  ),
                  UsersList(
                    users: s.patients,
                    state: s,
                    tab: UsersTab.patients,
                  ),
                ],
              ),
            ),
          ),

          AppBottomNav(
            index: _index,
            onTap: _onBottomNav,
            items: [
              BottomNavItem(icon: SvgPicture.asset(AppAssets.heartIcon)),
              BottomNavItem(icon: SvgPicture.asset(AppAssets.searchIcon)),
              BottomNavItem(icon: SvgPicture.asset(AppAssets.profileIcon)),
            ],
          ),
        ],
      ),
    );
  }
}