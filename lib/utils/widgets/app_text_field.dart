import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String hintText;
  final Widget? prefixIcon;

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  const AppTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.controller,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    );

    return TextField(
      controller: controller,
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        border: border,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13), // ~46px
        prefixIcon: prefixIcon == null
            ? null
            : Padding(
          padding: const EdgeInsets.only(left: 12, right: 8),
          child: prefixIcon!,
        ),
        prefixIconConstraints: prefixIcon == null
            ? null
            : const BoxConstraints(minWidth: 44, minHeight: 44),
      ),
    );
  }
}