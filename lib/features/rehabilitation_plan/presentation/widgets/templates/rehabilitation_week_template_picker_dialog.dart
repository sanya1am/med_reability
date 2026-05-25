import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:med_reability/features/rehabilitation_plan/domain/entities/rehabilitation_program_template.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/widgets/templates/rehabilitation_template_tile.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_secondary_button.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';

import '../rehabilitation_plan_dialog_frame.dart';

Future<RehabilitationProgramWeekTemplate?> showRehabilitationWeekTemplatePickerDialog({
  required BuildContext context,
  required List<RehabilitationProgramWeekTemplate> templates,
  required ValueChanged<String> onDeleteTemplate,
}) {
  return showRehabilitationPlanDialog<RehabilitationProgramWeekTemplate>(
    context: context,
    builder: (context) {
      return _WeekTemplatePickerDialog(
        templates: templates,
        onDeleteTemplate: onDeleteTemplate,
      );
    },
  );
}

class _WeekTemplatePickerDialog extends StatefulWidget {
  final List<RehabilitationProgramWeekTemplate> templates;
  final ValueChanged<String> onDeleteTemplate;

  const _WeekTemplatePickerDialog({
    required this.templates,
    required this.onDeleteTemplate,
  });

  @override
  State<_WeekTemplatePickerDialog> createState() =>
      _WeekTemplatePickerDialogState();
}

class _WeekTemplatePickerDialogState extends State<_WeekTemplatePickerDialog> {
  String? selectedTemplateId;
  late List<RehabilitationProgramWeekTemplate> localTemplates;

  @override
  void initState() {
    super.initState();

    localTemplates = List.of(widget.templates);
    selectedTemplateId = localTemplates.isEmpty ? null : localTemplates.first.id;
  }

  @override
  Widget build(BuildContext context) {
    return RehabilitationPlanDialogFrame(
      maxWidth: 560,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Выбрать шаблон недели',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(height: 24),

          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 340,
            ),
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
    );
  }

  RehabilitationProgramWeekTemplate? _findSelectedTemplate() {
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