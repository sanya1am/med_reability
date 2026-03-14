import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../utils/widgets/stub_page.dart';
import '../../../auth/presentation/view_model/auth_view_model.dart';

class AdminHomePage extends ConsumerWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StubPage(
      title: 'Админ клиники',
      actions: [
        IconButton(
          onPressed: () => ref.read(authViewModelProvider.notifier).logout(),
          icon: const Icon(Icons.logout),
        )
      ],
    );
  }
}