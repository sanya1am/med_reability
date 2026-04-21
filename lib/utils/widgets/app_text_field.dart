import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

class AppTextField extends StatelessWidget {
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;

  final bool obscureText;
  final bool readOnly;
  final bool enabled;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;

  const AppTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.onChanged,
    this.onTap,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide.none,
    );

    return TextField(
      controller: controller,
      onChanged: onChanged,
      onTap: onTap,
      obscureText: obscureText,
      readOnly: readOnly,
      enabled: enabled,
      showCursor: !readOnly,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: 16,
        color: colors.textPrimary,
      ),
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: TextStyle(
          color: colors.hint,
          fontSize: 16,
        ),
        filled: true,
        fillColor: colors.surface,
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        disabledBorder: border,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 13,
        ),
        prefixIcon: prefixIcon == null
            ? null
            : Padding(
          padding: const EdgeInsets.only(left: 12, right: 8),
          child: prefixIcon!,
        ),
        prefixIconConstraints: prefixIcon == null
            ? null
            : const BoxConstraints(minWidth: 44, minHeight: 44),
        suffixIcon: suffixIcon == null
            ? null
            : Padding(
          padding: const EdgeInsets.only(right: 12, left: 8),
          child: suffixIcon!,
        ),
        suffixIconConstraints: suffixIcon == null
            ? null
            : const BoxConstraints(minWidth: 44, minHeight: 44),
      ),
    );
  }
}