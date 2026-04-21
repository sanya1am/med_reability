import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import '../../../../utils/widgets/app_text_field.dart';
import '../../../../utils/widgets/primary_button.dart';
import '../../../auth/presentation/view_model/auth_view_model.dart';

class AdminProfilePage extends ConsumerStatefulWidget {
  const AdminProfilePage({super.key});

  @override
  ConsumerState<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends ConsumerState<AdminProfilePage> {
  final firstCtrl = TextEditingController();
  final lastCtrl = TextEditingController();
  final patronymicCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  @override
  void dispose() {
    firstCtrl.dispose();
    lastCtrl.dispose();
    patronymicCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authViewModelProvider);
    final colors = context.appColors;

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Клиника: ${auth.session?.clinic.name ?? '-'}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                AppTextField(hintText: 'Фамилия', controller: lastCtrl),
                const SizedBox(height: 12),
                AppTextField(hintText: 'Имя', controller: firstCtrl),
                const SizedBox(height: 12),
                AppTextField(hintText: 'Отчество', controller: patronymicCtrl),
                const SizedBox(height: 12),
                AppTextField(
                  hintText: 'Email',
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  hintText: 'Телефон',
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 28),
                PrimaryButton(
                  text: 'Выйти',
                  onPressed: () => ref.read(authViewModelProvider.notifier).logout(),
                  textStyle: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}