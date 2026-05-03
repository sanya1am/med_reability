import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/features/admin/presentation/view_model/users_view_model.dart';
import 'package:med_reability/features/admin/presentation/widgets/user_role_dropdown.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';
import '../../../../features/auth/domain/entities/role.dart';
import '../../../../utils/widgets/app_text_field.dart';

class UserCreatePage extends ConsumerStatefulWidget {
  const UserCreatePage({super.key});

  @override
  ConsumerState<UserCreatePage> createState() => _UserCreatePageState();
}

class _UserCreatePageState extends ConsumerState<UserCreatePage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final firstCtrl = TextEditingController();
  final lastCtrl = TextEditingController();
  final patronymicCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  UserRole role = UserRole.patient;

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    firstCtrl.dispose();
    lastCtrl.dispose();
    patronymicCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final vm = ref.read(usersViewModelProvider.notifier);

    try {
      await vm.addUser(
        email: emailCtrl.text.trim(),
        password: passCtrl.text,
        firstName: firstCtrl.text.trim(),
        patronymic: patronymicCtrl.text.trim(),
        lastName: lastCtrl.text.trim(),
        phoneNumber: phoneCtrl.text.trim(),
        role: role,
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создать пользователя', ),
        titleTextStyle: Theme.of(context).textTheme.headlineMedium,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  const SizedBox(height: 12),
                  AppTextField(
                    hintText: 'Пароль',
                    controller: passCtrl,
                    obscureText: true,
                  ),
                  const SizedBox(height: 12),

                  UserRoleDropdown(
                    value: role,
                    onChanged: (v) => setState(() => role = v ?? role),
                  ),

                  const SizedBox(height: 60),
                  PrimaryButton(
                    text: 'Создать',
                    onPressed: _submit,
                    textStyle: Theme.of(context).textTheme.titleSmall,
                    height: 38,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}