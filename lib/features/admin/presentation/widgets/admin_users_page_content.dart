import 'package:flutter/material.dart';
import 'package:med_reability/features/admin/presentation/state/users_state.dart';
import 'package:med_reability/features/admin/presentation/widgets/users_list.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';

class AdminUsersPageContent extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final users = switch (tab) {
      UsersTab.doctors => state.doctors,
      UsersTab.patients => state.patients,
    };

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
                        title,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    SizedBox(
                      width: 170,
                      child: PrimaryButton(
                        text: 'Создать',
                        onPressed: onCreate,
                        height: 38,
                        textStyle: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
            ],
            Expanded(
              child: UsersList(
                users: users,
                state: state,
                tab: tab,
                padding: EdgeInsets.fromLTRB(
                  isDesktop ? 32 : 28,
                  isDesktop ? 16 : 16,
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