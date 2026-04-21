import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:med_reability/utils/widgets/app_text_field.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';

import '../../../../utils/assets/app_assets.dart';
import '../view_model/auth_view_model.dart';
import '../widgets/clinic_picker_sheet.dart';
import '../../domain/entities/clinic.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late final TextEditingController _clinicController;

  @override
  void initState() {
    super.initState();
    _clinicController = TextEditingController();
  }

  @override
  void dispose() {
    _clinicController.dispose();
    super.dispose();
  }

  Future<void> _pickClinic(BuildContext context) async {
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
  Widget build(BuildContext context) {
    final auth = ref.watch(authViewModelProvider);
    final vm = ref.read(authViewModelProvider.notifier);

    final clinicName = auth.selectedClinic?.name ?? '';
    if (_clinicController.text != clinicName) {
      _clinicController.text = clinicName;
      _clinicController.selection = TextSelection.collapsed(
        offset: _clinicController.text.length,
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Авторизация',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 48),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Введите свои данные',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 12),

                AppTextField(
                  hintText: 'Почта',
                  prefixIcon: SvgPicture.asset(
                    AppAssets.emailIcon,
                    fit: BoxFit.scaleDown,
                  ),
                  onChanged: vm.setEmail,
                ),
                const SizedBox(height: 12),

                AppTextField(
                  hintText: 'Пароль',
                  prefixIcon: SvgPicture.asset(
                    AppAssets.passwordIcon,
                    fit: BoxFit.scaleDown,
                  ),
                  obscureText: true,
                  onChanged: vm.setPassword,
                ),
                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Укажите поликлинику',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 12),

                AppTextField(
                  hintText: 'Поликлиника',
                  controller: _clinicController,
                  readOnly: true,
                  onTap: () => _pickClinic(context),
                  prefixIcon: SvgPicture.asset(
                    AppAssets.searchIcon,
                    fit: BoxFit.scaleDown,
                  ),
                ),

                const SizedBox(height: 24),

                PrimaryButton(
                  text: 'Войти',
                  loading: auth.loading,
                  onPressed: vm.login,
                  textStyle: Theme.of(context).textTheme.titleSmall,
                  height: 38,
                ),

                if (auth.error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    auth.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}