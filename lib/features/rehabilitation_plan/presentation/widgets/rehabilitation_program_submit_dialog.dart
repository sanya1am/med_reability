import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_secondary_button.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';

Future<DateTime?> showRehabilitationProgramSubmitDialog({
  required BuildContext context,
  required DateTime initialDate,
  required bool isEdit,
}) {
  return showDialog<DateTime>(
    context: context,
    barrierColor: Colors.black.withOpacity(0.12),
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5,
          sigmaY: 5,
        ),
        child: _RehabilitationProgramSubmitDialog(
          initialDate: initialDate,
          isEdit: isEdit,
        ),
      );
    },
  );
}

class _RehabilitationProgramSubmitDialog extends StatefulWidget {
  final DateTime initialDate;
  final bool isEdit;

  const _RehabilitationProgramSubmitDialog({
    required this.initialDate,
    required this.isEdit,
  });

  @override
  State<_RehabilitationProgramSubmitDialog> createState() =>
      _RehabilitationProgramSubmitDialogState();
}

class _RehabilitationProgramSubmitDialogState
    extends State<_RehabilitationProgramSubmitDialog> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();

    selectedDate = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
      widget.initialDate.day,
    );
  }

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
            Text(
              widget.isEdit ? 'Сохранить план' : 'Назначить план',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 22),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Дата начала',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ),

            const SizedBox(height: 8),

            GestureDetector(
              onTap: _pickDate,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: double.infinity,
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _formatDate(selectedDate),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 18,
                      color: colors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: 'Отмена',
                    onPressed: () => Navigator.pop(context),
                    height: 38,
                    textStyle: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: PrimaryButton(
                    text: widget.isEdit ? 'Сохранить' : 'Назначить',
                    onPressed: () => Navigator.pop(context, selectedDate),
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

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (picked == null) return;

    setState(() {
      selectedDate = DateTime(
        picked.year,
        picked.month,
        picked.day,
      );
    });
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString().padLeft(4, '0');

    return '$day.$month.$year';
  }
}