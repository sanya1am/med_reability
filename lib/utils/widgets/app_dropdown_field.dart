import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

class AppDropdownField<T> extends StatelessWidget {
  final T value;
  final ValueChanged<T?> onChanged;
  final List<DropdownMenuItem<T>> items;
  final String? hintText;

  const AppDropdownField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.items,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide.none,
    );

    return DropdownButtonFormField<T>(
      value: value,
      isExpanded: true,
      dropdownColor: colors.surface,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: colors.textPrimary,
      ),
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: colors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: colors.hint,
          fontSize: 16,
        ),
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        disabledBorder: border,
        errorBorder: border,
        focusedErrorBorder: border,
      ),
      items: items,
      onChanged: onChanged,
    );
  }
}