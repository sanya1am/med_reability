import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reability/features/admin/domain/entities/clinic_user.dart';
import 'package:med_reability/features/admin/domain/entities/person_lite.dart';
import 'package:med_reability/features/admin/domain/entities/user_image_file.dart';
import 'package:med_reability/features/admin/presentation/view_model/user_form_view_model.dart';
import 'package:med_reability/features/admin/presentation/widgets/user_role_selector.dart';
import 'package:med_reability/features/profile/presentation/widgets/profile_avatar_picker.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_text_field.dart';
import 'package:med_reability/utils/widgets/app_top_actions_bar.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';
import 'package:med_reability/utils/widgets/password_requirements_text.dart';
import '../../../../core/router/app_route_names.dart';
import '../../../../utils/widgets/app_breadcrumbs.dart';

class UserFormPage extends ConsumerStatefulWidget {
  final ClinicUser? initialUser;

  const UserFormPage({
    super.key,
    this.initialUser,
  });

  @override
  ConsumerState<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends ConsumerState<UserFormPage> {
  late final TextEditingController emailCtrl;
  late final TextEditingController passCtrl;
  late final TextEditingController firstCtrl;
  late final TextEditingController lastCtrl;
  late final TextEditingController patronymicCtrl;
  late final TextEditingController phoneCtrl;

  @override
  void initState() {
    super.initState();

    final user = widget.initialUser;

    emailCtrl = TextEditingController(text: user?.email ?? '');
    passCtrl = TextEditingController();
    passCtrl.addListener(_onPasswordChanged);
    firstCtrl = TextEditingController(text: user?.firstName ?? '');
    lastCtrl = TextEditingController(text: user?.lastName ?? '');
    patronymicCtrl = TextEditingController(text: user?.patronymic ?? '');
    phoneCtrl = TextEditingController(text: user?.phoneNumber ?? '');
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.removeListener(_onPasswordChanged);
    passCtrl.dispose();
    firstCtrl.dispose();
    lastCtrl.dispose();
    patronymicCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }

  void _onPasswordChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final bytes = file.bytes;

    if (bytes == null) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось прочитать выбранное изображение'),
        ),
      );

      return;
    }

    ref
        .read(userFormViewModelProvider(widget.initialUser).notifier)
        .setImage(
      UserImageFile(
        name: file.name,
        bytes: bytes,
      ),
    );
  }

  Future<void> _submit() async {
    final vm = ref.read(
      userFormViewModelProvider(widget.initialUser).notifier,
    );

    final success = await vm.submit(
      email: emailCtrl.text,
      password: passCtrl.text,
      firstName: firstCtrl.text,
      patronymic: patronymicCtrl.text,
      lastName: lastCtrl.text,
      phoneNumber: phoneCtrl.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop(true);
      return;
    }

    final error = ref
        .read(userFormViewModelProvider(widget.initialUser))
        .errorMessage;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error ?? 'Не удалось сохранить пользователя'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(
      userFormViewModelProvider(widget.initialUser),
    );

    final textTheme = Theme.of(context).textTheme;
    final isEdit = formState.isEdit;

    final location = GoRouterState.of(context).uri.path;
    final isPatientsBranch = location.startsWith('/admin/patients');

    final parentLabel = isPatientsBranch ? 'Пациенты' : 'Инструкторы';
    final parentRoute = isPatientsBranch
        ? AppRouteNames.adminPatients
        : AppRouteNames.adminDoctors;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;

            final form = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isDesktop) ...[
                  AppBreadcrumbs(
                    onBack: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.goNamed(parentRoute);
                      }
                    },
                    items: [
                      AppBreadcrumbItem(
                        label: parentLabel,
                        onTap: () => context.goNamed(parentRoute),
                      ),
                      AppBreadcrumbItem(
                        label: isEdit ? 'Редактирование пользователя' : 'Создание пользователя',
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                ] else ...[
                  AppTopActionsBar(
                    onBack: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    isEdit ? 'Редактирование пользователя' : 'Создание пользователя',
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 20),
                ],

                Center(
                  child: ProfileAvatarPicker(
                    imageUrl: widget.initialUser?.imageUrl,
                    imageBytes: formState.image?.bytes,
                    onTap: _pickImage,
                  ),
                ),

                const SizedBox(height: 22),

                if (!isEdit) ...[
                  Text(
                    'Роль',
                    style: textTheme.titleSmall?.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  UserRoleSelector(
                    value: formState.role,
                    onChanged: ref
                        .read(userFormViewModelProvider(widget.initialUser).notifier)
                        .setRole,
                  ),
                  const SizedBox(height: 16),
                ],

                Text(
                  'Данные пользователя',
                  style: textTheme.titleSmall?.copyWith(fontSize: 18),
                ),

                const SizedBox(height: 16),

                AppTextField(hintText: 'Фамилия', controller: lastCtrl),
                const SizedBox(height: 16),
                AppTextField(hintText: 'Имя', controller: firstCtrl),
                const SizedBox(height: 16),
                AppTextField(hintText: 'Отчество', controller: patronymicCtrl),
                const SizedBox(height: 16),
                AppTextField(
                  hintText: 'Email',
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  hintText: 'Телефон',
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                ),

                if (!isEdit) ...[
                  const SizedBox(height: 16),
                  AppTextField(
                    hintText: 'Пароль',
                    controller: passCtrl,
                    obscureText: true,
                  ),
                  PasswordRequirementsText(
                    password: passCtrl.text,
                  ),
                ],

                const SizedBox(height: 28),

                PrimaryButton(
                  text: isEdit ? 'Сохранить' : 'Создать',
                  onPressed: formState.isSubmitting ? null : _submit,
                  loading: formState.isSubmitting,
                  height: 38,
                  textStyle: textTheme.titleSmall,
                ),
              ],
            );

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                isDesktop ? 28 : 28,
                12,
                isDesktop ? 28 : 28,
                32,
              ),
              child: isDesktop
                  ? form
                  : Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: form,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}