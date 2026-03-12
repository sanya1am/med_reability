import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/features/auth/presentation/widgets/login_button.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Авторизация',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600)),
                const SizedBox(height: 24),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Введите свои данные', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 12),

                TextField(
                  onChanged: vm.setEmail,
                  style: TextStyle(fontSize: 20),
                  decoration: const InputDecoration(
                    hintText: 'Почта',
                    hintStyle: TextStyle(fontSize: 20),
                    prefixIcon: Icon(Icons.mail),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: vm.setPassword,
                  obscureText: true,
                  style: TextStyle(fontSize: 20),
                  decoration: const InputDecoration(
                    hintText: 'Пароль',
                    hintStyle: TextStyle(fontSize: 20),
                    prefixIcon: Icon(Icons.key),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14)),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Укажите поликлинику', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 10),

                InkWell(
                  onTap: () => _pickClinic(context, ref),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Поликлиника',
                      hintStyle: TextStyle(fontSize: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                      ),
                    ),
                    child: Text(auth.selectedClinic?.name ?? '', style: TextStyle(fontSize: 20)),
                  ),
                ),

                const SizedBox(height: 16),

                LoginButton(
                  onPressed: auth.loading ? () {} : vm.login,
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