import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/features/admin/presentation/page/admin_profile_page.dart';
import 'package:med_reability/features/admin/presentation/page/user_create_page.dart';
import 'package:med_reability/features/admin/presentation/view_model/users_view_model.dart';
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
      ref.read(usersVmProvider.notifier).refresh();
    });
  }

  Future<void> _openCreate() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const UserCreatePage()),
    );
    if (created == true) {
      await ref.read(usersVmProvider.notifier).refresh();
    }
  }

  void _onBottomNav(int i) {
    if (_index == i) return;
    setState(() => _index = i);
    if (i == 0 || i == 1) {
      ref.read(usersVmProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(usersVmProvider);
    final vm = ref.read(usersVmProvider.notifier);
    final headerTitle = (_index == 2) ? 'Профиль' : 'Пользователи';

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
                index: _index, // 0/1
                children: [
                  _UsersList(users: s.doctors, onDeactivate: vm.deactivate),
                  _UsersList(users: s.patients, onDeactivate: vm.deactivate),
                ],
              ),
            ),
          ),

          AppBottomNav(
            index: _index,
            onTap: _onBottomNav,
            items: const [
              BottomNavItem(icon: Icons.medical_services_outlined),
              BottomNavItem(icon: Icons.person_outline),
              BottomNavItem(icon: Icons.account_circle_outlined),
            ],
          ),
        ],
      ),
    );
  }
}

class _UsersList extends StatelessWidget {
  final List users;
  final void Function(String userId) onDeactivate;

  const _UsersList({
    required this.users,
    required this.onDeactivate,
  });

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) return const Center(child: Text('Пусто'));

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      itemCount: users.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final u = users[i] as dynamic;
        final String id = u.id;
        final String fullName = u.fullName;
        final String email = u.email;
        final bool isActive = u.isActive;

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F6F6),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fullName, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(email, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                isActive ? 'Активен' : 'Неактивен',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.black : const Color(0xFF9A9A9A),
                ),
              ),
              const SizedBox(width: 10),
              if (isActive)
                GestureDetector(
                  onTap: () => onDeactivate(id),
                  child: const Icon(Icons.block, size: 22),
                ),
            ],
          ),
        );
      },
    );
  }
}