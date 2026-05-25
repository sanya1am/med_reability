import 'package:flutter/material.dart';
import 'package:med_reability/features/admin/domain/entities/clinic_user.dart';
import 'package:med_reability/features/admin/presentation/state/users_state.dart';
import 'package:med_reability/features/admin/presentation/widgets/users_list.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_text_field.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';

class AdminUsersPageContent extends StatefulWidget {
  final String title;
  final UsersTab tab;
  final UsersState state;
  final VoidCallback onCreate;

  const AdminUsersPageContent({
    super.key,
    required this.title,
    required this.tab,
    required this.state,
    required this.onCreate,
  });

  @override
  State<AdminUsersPageContent> createState() => _AdminUsersPageContentState();
}

class _AdminUsersPageContentState extends State<AdminUsersPageContent> {
  final searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchCtrl.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchCtrl.removeListener(_onSearchChanged);
    searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final sourceUsers = switch (widget.tab) {
      UsersTab.doctors => widget.state.doctors,
      UsersTab.patients => widget.state.patients,
    };

    final query = searchCtrl.text.trim().toLowerCase();

    final filteredUsers = query.isEmpty
        ? sourceUsers
        : sourceUsers.where((user) {
      final haystack = [
        user.fullName,
        user.email,
        user.phoneNumber,
      ].join(' ').toLowerCase();

      return haystack.contains(query);
    }).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDesktop) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 28, 32, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onCreate,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            Padding(
              padding: EdgeInsets.fromLTRB(
                isDesktop ? 32 : 28,
                isDesktop ? 0 : 16,
                isDesktop ? 32 : 28,
                0,
              ),
              child: AppTextField(
                hintText: 'Найти пользователя',
                controller: searchCtrl,
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: filteredUsers.isEmpty
                  ? Center(
                child: Text(
                  query.isEmpty
                      ? 'Пусто'
                      : 'По вашему запросу ничего не найдено',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              )
                  : UsersList(
                users: filteredUsers.cast<ClinicUser>(),
                state: widget.state,
                tab: widget.tab,
                padding: EdgeInsets.fromLTRB(
                  isDesktop ? 32 : 28,
                  0,
                  isDesktop ? 32 : 28,
                  isDesktop ? 32 : 120,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}