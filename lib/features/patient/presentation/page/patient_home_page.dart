import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/features/auth/presentation/view_model/auth_view_model.dart';
import '../../../../utils/widgets/stub_page.dart';

class PatientHomePage extends ConsumerWidget {
  const PatientHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StubPage(
      title: 'Пациент',
      actions: [
        IconButton(
          onPressed: () => ref.read(authViewModelProvider.notifier).logout(),
          icon: const Icon(Icons.logout),
        )
      ],
    );
  }
}