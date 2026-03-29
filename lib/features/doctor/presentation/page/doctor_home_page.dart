import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:med_reability/features/auth/presentation/view_model/user_me_view_model.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';


class DoctorHomePage extends ConsumerWidget {
  const DoctorHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meAsync = ref.watch(userMeViewModelProvider);

    return meAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Ошибка: $e')),
      data: (me) {
        if (me == null) return const SizedBox.shrink();

        return ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 18,
                    offset: Offset(0, 8),
                    color: Color(0x22000000),
                  )
                ],
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundColor: Color(0xFFEFEFEF),
                    child: Icon(Icons.person, size: 44, color: Colors.black),
                  ),
                  const SizedBox(height: 12),
                  Text(me.fullFullName, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 20),
                  const Divider(height: 24),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Почта', style: Theme.of(context).textTheme.titleSmall),
                  ),
                  const SizedBox(height: 2),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(me.email, style: Theme.of(context).textTheme.bodySmall),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Телефон', style: Theme.of(context).textTheme.titleSmall),
                  ),
                  const SizedBox(height: 2),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(me.phoneNumber, style: Theme.of(context).textTheme.bodySmall),
                  ),

                  const SizedBox(height: 16),
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: IntrinsicWidth(
                  //     child: PrimaryButton(
                  //       text: 'Выйти',
                  //       onPressed: () => ref.read(authViewModelProvider.notifier).logout(),
                  //       height: 38,
                  //       textStyle: Theme.of(context).textTheme.titleSmall,
                  //     ),
                  //   ),
                  // ),
                  PrimaryButton(
                    text: 'Выйти',
                    onPressed: () => ref.read(authViewModelProvider.notifier).logout(),
                    height: 38,
                    textStyle: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}