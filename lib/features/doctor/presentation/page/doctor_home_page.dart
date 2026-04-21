import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:med_reability/features/auth/presentation/view_model/user_me_view_model.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';

class DoctorHomePage extends ConsumerWidget {
  const DoctorHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final meAsync = ref.watch(userMeViewModelProvider);
    final colors = context.appColors;

    return meAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(
          'Ошибка: $e',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colors.textPrimary,
          ),
        ),
      ),
      data: (me) {
        if (me == null) return const SizedBox.shrink();

        return ListView(
          padding: const EdgeInsets.fromLTRB(28, 16, 28, 120),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.18)
                        : const Color(0x22000000),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: colors.surfaceAlt,
                    child: Icon(
                      Icons.person,
                      size: 44,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    me.fullFullName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 20),
                  Divider(
                    height: 24,
                    color: colors.border,
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Почта',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      me.email,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Телефон',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      me.phoneNumber,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    text: 'Выйти',
                    onPressed: () =>
                        ref.read(authViewModelProvider.notifier).logout(),
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