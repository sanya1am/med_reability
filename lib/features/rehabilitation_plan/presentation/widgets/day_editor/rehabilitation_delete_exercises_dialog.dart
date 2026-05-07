import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_secondary_button.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';

Future<bool?> showRehabilitationDeleteExercisesDialog({
  required BuildContext context,
}) {
  return showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withOpacity(0.12),
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5,
          sigmaY: 5,
        ),
        child: const _DeleteExercisesDialog(),
      );
    },
  );
}

class _DeleteExercisesDialog extends StatelessWidget {
  const _DeleteExercisesDialog();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 22),
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(26, 28, 26, 26),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.info_outline,
              size: 42,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 18),
            Text(
              'Вы точно хотите удалить\nвыбранные упражнения?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: 'Отмена',
                    onPressed: () => Navigator.pop(context, false),
                    height: 38,
                    textStyle: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PrimaryButton(
                    text: 'Удалить',
                    onPressed: () => Navigator.pop(context, true),
                    height: 38,
                    textStyle: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}