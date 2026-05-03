import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:med_reability/features/auth/presentation/view_model/user_me_view_model.dart';
import 'package:med_reability/features/profile/presentation/widgets/profile_avatar_picker.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/user_info_card.dart';

import '../../../profile/presentation/page/edit_profile_page.dart';

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
            UserInfoCard(
              fullName: me.fullFullName,
              email: me.email,
              phoneNumber: me.phoneNumber,
              actionText: 'Выйти',
              onActionPressed: () =>
                  ref.read(authViewModelProvider.notifier).logout(),
              onEditPressed: () async {
                final changed = await Navigator.of(context).push<bool>(
                  MaterialPageRoute(
                    builder: (_) => const EditProfilePage(),
                  ),
                );

                if (changed == true) {
                  ref.invalidate(userMeViewModelProvider);
                }
              },
              avatar: ProfileAvatarPicker(
                imageUrl: me.imageUrl,
                imageBytes: null,
                onTap: () {},
              ),
            ),
          ],
        );
      },
    );
  }
}