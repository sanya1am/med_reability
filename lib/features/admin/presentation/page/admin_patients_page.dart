import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reability/core/router/app_route_names.dart';
import 'package:med_reability/features/admin/presentation/view_model/users_view_model.dart';
import 'package:med_reability/features/admin/presentation/widgets/admin_users_page_content.dart';
import '../widgets/users_list.dart';


class AdminPatientsPage extends ConsumerWidget {
  const AdminPatientsPage({super.key});

  Future<void> _openCreate(BuildContext context, WidgetRef ref) async {
    final created = await context.pushNamed<bool>(
      AppRouteNames.adminCreateUser,
    );

    if (created == true) {
      await ref.read(usersViewModelProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(usersViewModelProvider);

    return data.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (e, _) => Center(
        child: Text('Ошибка: $e'),
      ),
      data: (state) {
        return AdminUsersPageContent(
          title: 'Пациенты',
          tab: UsersTab.patients,
          state: state,
          onCreate: () => _openCreate(context, ref),
        );
      },
    );
  }
}