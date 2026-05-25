import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_secondary_button.dart';
import 'package:med_reability/utils/widgets/app_text_field.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';

import '../../../../utils/validation/password_validator.dart';
import '../../../../utils/widgets/password_requirements_text.dart';

Future<bool?> showChangePasswordDialog({
  required BuildContext context,
  required Future<String?> Function(
      String currentPassword,
      String newPassword,
      ) onSubmit,
}) {
  return showGeneralDialog<bool>(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'change_password',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (_, __, ___) {
      return _ChangePasswordDialog(onSubmit: onSubmit);
    },
    transitionBuilder: (_, animation, __, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );

      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class _ChangePasswordDialog extends StatefulWidget {
  final Future<String?> Function(String currentPassword, String newPassword)
  onSubmit;

  const _ChangePasswordDialog({
    required this.onSubmit,
  });

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final currentCtrl = TextEditingController();
  final newCtrl = TextEditingController();
  final repeatCtrl = TextEditingController();

  bool obscureCurrent = true;
  bool obscureNew = true;
  bool obscureRepeat = true;
  bool isSubmitting = false;
  String? errorText;

  @override
  void initState() {
    super.initState();
    newCtrl.addListener(_onPasswordChanged);
    repeatCtrl.addListener(_onPasswordChanged);
  }

  void _onPasswordChanged() {
    if (!mounted) return;
    setState(() {
      errorText = null;
    });
  }

  @override
  void dispose() {
    newCtrl.removeListener(_onPasswordChanged);
    repeatCtrl.removeListener(_onPasswordChanged);
    currentCtrl.dispose();
    newCtrl.dispose();
    repeatCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final current = currentCtrl.text;
    final next = newCtrl.text;
    final repeat = repeatCtrl.text;

    if (current.isEmpty || next.isEmpty || repeat.isEmpty) {
      setState(() {
        errorText = 'Заполните все поля';
      });
      return;
    }

    final passwordValidation = PasswordValidator.validate(next);

    if (!passwordValidation.isValid) {
      setState(() {
        errorText = passwordValidation.errorText;
      });
      return;
    }

    if (next != repeat) {
      setState(() {
        errorText = 'Новый пароль и повтор пароля не совпадают';
      });
      return;
    }

    setState(() {
      isSubmitting = true;
      errorText = null;
    });

    final error = await widget.onSubmit(current, next);

    if (!mounted) return;

    if (error == null) {
      Navigator.pop(context, true);
      return;
    }

    setState(() {
      isSubmitting = false;
      errorText = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
              child: Container(
                color: Colors.black.withOpacity(isDark ? 0.18 : 0.07),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
                    decoration: BoxDecoration(
                      //color: isDark ? colors.surface : Colors.white,
                      color: colors.dialogBackground,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                          color: colors.dialogShadow,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Изменить пароль',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        _PasswordInputBlock(
                          label: 'Старый пароль',
                          hintText: 'Введите ваш старый пароль',
                          controller: currentCtrl,
                          obscureText: obscureCurrent,
                          onToggleObscure: () {
                            setState(() {
                              obscureCurrent = !obscureCurrent;
                            });
                          },
                        ),
                        const SizedBox(height: 18),

                        _PasswordInputBlock(
                          label: 'Новый пароль',
                          hintText: 'Введите новый пароль',
                          controller: newCtrl,
                          obscureText: obscureNew,
                          onToggleObscure: () {
                            setState(() {
                              obscureNew = !obscureNew;
                            });
                          },
                        ),

                        PasswordRequirementsText(
                          password: newCtrl.text,
                        ),

                        const SizedBox(height: 18),

                        _PasswordInputBlock(
                          label: 'Повторите пароль',
                          hintText: 'Повторите пароль',
                          controller: repeatCtrl,
                          obscureText: obscureRepeat,
                          onToggleObscure: () {
                            setState(() {
                              obscureRepeat = !obscureRepeat;
                            });
                          },
                        ),

                        if (errorText != null) ...[
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              errorText!,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 22),

                        Row(
                          children: [
                            Expanded(
                              child: SecondaryButton(
                                text: 'Назад',
                                onPressed: isSubmitting
                                    ? null
                                    : () => Navigator.pop(context, false),
                                height: 38,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: PrimaryButton(
                                text: 'Сохранить',
                                onPressed: isSubmitting ? null : _submit,
                                loading: isSubmitting,
                                height: 38,
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _PasswordInputBlock extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback onToggleObscure;

  const _PasswordInputBlock({
    required this.label,
    required this.hintText,
    required this.controller,
    required this.obscureText,
    required this.onToggleObscure,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: isDark
          ? BorderSide.none
          : BorderSide(
        color: colors.border,
        width: 1,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.hint,
            ),
            filled: true,
            fillColor: colors.surface,
            border: border,
            enabledBorder: border,
            focusedBorder: border,
            disabledBorder: border,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14,
            ),
            suffixIcon: IconButton(
              onPressed: onToggleObscure,
              icon: Icon(
                obscureText
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 22,
                color: colors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}