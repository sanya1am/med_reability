import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

Future<T?> showRehabilitationPlanDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  return showDialog<T>(
    context: context,
    barrierColor: Colors.black.withOpacity(0.12),
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5,
          sigmaY: 5,
        ),
        child: builder(context),
      );
    },
  );
}

class RehabilitationPlanDialogFrame extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsets padding;

  const RehabilitationPlanDialogFrame({
    super.key,
    required this.child,
    this.maxWidth = 560,
    this.padding = const EdgeInsets.fromLTRB(28, 28, 28, 28),
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 24,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          maxHeight: screenHeight - 48,
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: colors.dialogBackground,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 24,
                offset: const Offset(0, 8),
                color: colors.dialogShadow,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}