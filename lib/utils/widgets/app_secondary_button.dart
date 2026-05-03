import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool loading;
  final double height;
  final TextStyle? textStyle;
  final bool showBorder;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.loading = false,
    this.height = 52,
    this.textStyle,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final effectiveStyle = textStyle ??
        Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: colors.secondaryButtonForeground,
        );

    return SizedBox(
      width: double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: (onPressed == null || loading) ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: colors.secondaryButtonBackground,
          foregroundColor: colors.secondaryButtonForeground,
          disabledBackgroundColor:
          colors.secondaryButtonBackground.withOpacity(0.7),
          disabledForegroundColor:
          colors.secondaryButtonForeground.withOpacity(0.7),
          elevation: 0,
          side: BorderSide(
            color: showBorder
                ? colors.secondaryButtonBorder
                : Colors.transparent,
            width: showBorder ? 1 : 0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: effectiveStyle,
        ),
        child: loading
            ? SizedBox(
          height: 16,
          width: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              colors.secondaryButtonForeground,
            ),
          ),
        )
            : Text(text),
      ),
    );
  }
}