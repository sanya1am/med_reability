import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:med_reability/features/rehabilitation_plan/domain/entities/rehabilitation_program_template.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/widgets/templates/rehabilitation_template_tile.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_secondary_button.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';

Future<RehabilitationProgramDayTemplate?>
showRehabilitationDayTemplatePickerDialog({
  required BuildContext context,
  required List<RehabilitationProgramDayTemplate> templates,
  required ValueChanged<String> onDeleteTemplate,
}) {
  return showDialog<RehabilitationProgramDayTemplate>(
    context: context,
    barrierColor: Colors.black.withOpacity(0.12),
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: _DayTemplatePickerDialog(
          templates: templates,
          onDeleteTemplate: onDeleteTemplate,
        ),
      );
    },
  );
}

class _DayTemplatePickerDialog extends StatefulWidget {
  final List<RehabilitationProgramDayTemplate> templates;
  final ValueChanged<String> onDeleteTemplate;

  const _DayTemplatePickerDialog({
    required this.templates,
    required this.onDeleteTemplate,
  });

  @override
  State<_DayTemplatePickerDialog> createState() =>
      _DayTemplatePickerDialogState();
}

class _DayTemplatePickerDialogState extends State<_DayTemplatePickerDialog> {
  String? selectedTemplateId;
  late List<RehabilitationProgramDayTemplate> localTemplates;

  @override
  void initState() {
    super.initState();

    localTemplates = List.of(widget.templates);
    selectedTemplateId = localTemplates.isEmpty ? null : localTemplates.first.id;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 22),
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(28, 28, 28, 28),
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
              'Выбрать шаблон дня',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: localTemplates.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final template = localTemplates[index];

                  return RehabilitationTemplateTile(
                    title: template.name,
                    selected: template.id == selectedTemplateId,
                    onTap: () {
                      setState(() {
                        selectedTemplateId = template.id;
                      });
                    },
                    onDelete: () {
                      widget.onDeleteTemplate(template.id);
                      setState(() {
                        localTemplates.removeWhere(
                              (item) => item.id == template.id,
                        );

                        if (selectedTemplateId == template.id) {
                          selectedTemplateId = localTemplates.isEmpty
                              ? null
                              : localTemplates.first.id;
                        }
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: 'Назад',
                    onPressed: () => Navigator.of(context).pop(),
                    height: 38,
                    textStyle: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    text: 'Сохранить',
                    onPressed: selectedTemplateId == null
                        ? null
                        : () {
                      final selected = _findSelectedTemplate();
                      if (selected == null) return;
                      Navigator.of(context).pop(selected);
                    },
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

  RehabilitationProgramDayTemplate? _findSelectedTemplate() {
    final id = selectedTemplateId;
    if (id == null) return null;

    for (final template in localTemplates) {
      if (template.id == id) {
        return template;
      }
    }

    return null;
  }
}