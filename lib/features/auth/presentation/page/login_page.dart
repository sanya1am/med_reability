import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:med_reability/features/auth/presentation/widgets/login_button.dart';
import 'package:med_reability/utils/widgets/app_text_field.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';
import '../../../../utils/assets/app_assets.dart';
import '../view_model/auth_view_model.dart';
import '../widgets/clinic_picker_sheet.dart';
import '../../domain/entities/clinic.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  Future<void> _pickClinic(BuildContext context, WidgetRef ref) async {
    final picked = await showModalBottomSheet<Clinic>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const ClinicPickerSheet(),
    );
    if (picked != null) {
      ref.read(authViewModelProvider.notifier).setClinic(picked);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authViewModelProvider);
    final vm = ref.read(authViewModelProvider.notifier);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Авторизация', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 48),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Введите свои данные', style: Theme.of(context).textTheme.bodyMedium),
                ),
                const SizedBox(height: 20),

                AppTextField(
                  hintText: 'Почта',
                  prefixIcon: SvgPicture.asset(AppAssets.emailIcon, fit: BoxFit.scaleDown),
                  onChanged: vm.setEmail,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  hintText: 'Пароль',
                  prefixIcon: SvgPicture.asset(AppAssets.passwordIcon, fit: BoxFit.scaleDown),
                  obscureText: true,
                  onChanged: vm.setPassword,
                ),
                const SizedBox(height: 24),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Укажите поликлинику', style: Theme.of(context).textTheme.bodyMedium),
                ),
                const SizedBox(height: 20),

                InkWell(
                  onTap: () => _pickClinic(context, ref),
                  child: InputDecorator(
                    isEmpty: auth.selectedClinic == null,
                    decoration: InputDecoration(
                      prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 12, right: 8),
                        child: SvgPicture.asset(AppAssets.searchIcon, fit: BoxFit.scaleDown),
                      ),
                      hintText: 'Поликлиника',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(auth.selectedClinic?.name ?? '', style: TextStyle(fontSize: 20)),
                  ),
                ),

                const SizedBox(height: 32),

                PrimaryButton(
                  text: 'Войти',
                  loading: auth.loading,
                  onPressed: vm.login,
                  textStyle: Theme.of(context).textTheme.titleMedium,
                ),

                if (auth.error != null) ...[
                  const SizedBox(height: 12),
                  Text(auth.error!, style: const TextStyle(color: Colors.red)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}