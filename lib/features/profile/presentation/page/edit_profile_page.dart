import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:med_reability/utils/widgets/app_secondary_button.dart';
import 'package:med_reability/utils/widgets/app_top_actions_bar.dart';
import 'package:med_reability/utils/assets/app_assets.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_circle_icon_button.dart';
import 'package:med_reability/utils/widgets/app_text_field.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';
import '../state/edit_profile_state.dart';
import '../view_model/edit_profile_view_model.dart';
import '../widgets/change_password_dialog.dart';
import '../widgets/profile_avatar_picker.dart';


class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final lastCtrl = TextEditingController();
  final firstCtrl = TextEditingController();
  final patronymicCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  bool _controllersHydrated = false;

  @override
  void dispose() {
    lastCtrl.dispose();
    firstCtrl.dispose();
    patronymicCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }

  void _hydrateControllersIfNeeded(EditProfileState state) {
    if (_controllersHydrated) return;

    lastCtrl.text = state.user.lastName;
    firstCtrl.text = state.user.firstName;
    patronymicCtrl.text = state.user.patronymic;
    emailCtrl.text = state.user.email;
    phoneCtrl.text = state.user.phoneNumber;

    _controllersHydrated = true;
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
    if (file.bytes == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось прочитать выбранное изображение'),
        ),
      );
      return;
    }

    ref.read(editProfileViewModelProvider.notifier).setPickedImage(
      bytes: file.bytes!,
      fileName: file.name,
    );
  }

  Future<void> _save(EditProfileState state) async {
    final error = await ref.read(editProfileViewModelProvider.notifier).saveProfile(
      firstName: firstCtrl.text,
      patronymic: patronymicCtrl.text,
      lastName: lastCtrl.text,
      email: emailCtrl.text,
      phoneNumber: phoneCtrl.text,
    );

    if (!mounted) return;

    if (error == null) {
      Navigator.pop(context, true);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error)),
    );
  }

  Future<void> _openChangePasswordDialog() async {
    final result = await showChangePasswordDialog(
      context: context,
      onSubmit: (currentPassword, newPassword) {
        return ref.read(editProfileViewModelProvider.notifier).submitPasswordChange(
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
      },
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пароль успешно изменен')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final stateAsync = ref.watch(editProfileViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: stateAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text(
              'Ошибка: $e',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
          data: (state) {
            _hydrateControllersIfNeeded(state);

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 12, 28, 24),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTopActionsBar(
                        onBack: () => Navigator.pop(context),
                        onNotify: () {},
                      ),
                      const SizedBox(height: 16),

                      Center(
                        child: ProfileAvatarPicker(
                          imageUrl: state.user.imageUrl,
                          imageBytes: state.pickedImageBytes,
                          onTap: _pickImage,
                        ),
                      ),
                      const SizedBox(height: 22),

                      Text('Фамилия', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      AppTextField(
                        hintText: 'Фамилия',
                        controller: lastCtrl,
                      ),
                      const SizedBox(height: 16),

                      Text('Имя', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      AppTextField(
                        hintText: 'Имя',
                        controller: firstCtrl,
                      ),
                      const SizedBox(height: 16),

                      Text('Отчество', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      AppTextField(
                        hintText: 'Отчество',
                        controller: patronymicCtrl,
                      ),
                      const SizedBox(height: 16),

                      Text('Почта', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      AppTextField(
                        hintText: 'Почта',
                        controller: emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),

                      Text('Телефон', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      AppTextField(
                        hintText: 'Телефон',
                        controller: phoneCtrl,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 20),

                      SecondaryButton(
                        text: 'Изменить пароль',
                        onPressed: _openChangePasswordDialog,
                        height: 38,
                        textStyle: Theme.of(context).textTheme.titleSmall,
                      ),

                      const SizedBox(height: 16),

                      PrimaryButton(
                        text: 'Сохранить',
                        onPressed: state.isSubmitting ? null : () => _save(state),
                        loading: state.isSubmitting,
                        height: 38,
                        textStyle: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}