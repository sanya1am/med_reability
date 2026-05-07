import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

enum RehabilitationProgramWeekMenuAction {
  saveAsTemplate,
  fillFromTemplate,
  delete,
}

class RehabilitationProgramWeekCard extends StatelessWidget {
  final int weekNumber;
  final bool isFilled;
  final VoidCallback onTap;
  final VoidCallback onSaveAsTemplate;
  final VoidCallback onFillFromTemplate;
  final VoidCallback onDelete;

  const RehabilitationProgramWeekCard({
    super.key,
    required this.weekNumber,
    required this.isFilled,
    required this.onTap,
    required this.onSaveAsTemplate,
    required this.onFillFromTemplate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 8, 16),
          child: Row(
            children: [
              Expanded(
                child: _WeekTextBlock(
                  weekNumber: weekNumber,
                  isFilled: isFilled,
                ),
              ),
              PopupMenuButton<RehabilitationProgramWeekMenuAction>(
                color: colors.surface,
                surfaceTintColor: Colors.transparent,
                elevation: 4,
                icon: Icon(
                  Icons.more_vert,
                  color: colors.textPrimary,
                ),
                onSelected: (action) {
                  switch (action) {
                    case RehabilitationProgramWeekMenuAction.saveAsTemplate:
                      onSaveAsTemplate();
                      break;

                    case RehabilitationProgramWeekMenuAction.fillFromTemplate:
                      onFillFromTemplate();
                      break;

                    case RehabilitationProgramWeekMenuAction.delete:
                      onDelete();
                      break;
                  }
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value:
                      RehabilitationProgramWeekMenuAction.saveAsTemplate,
                      child: Text(
                        'Сохранить как шаблон',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    PopupMenuItem(
                      value:
                      RehabilitationProgramWeekMenuAction.fillFromTemplate,
                      child: Text(
                        'Заполнить шаблоном',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    PopupMenuItem(
                      value: RehabilitationProgramWeekMenuAction.delete,
                      child: Text(
                        'Удалить',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeekTextBlock extends StatelessWidget {
  final int weekNumber;
  final bool isFilled;

  const _WeekTextBlock({
    required this.weekNumber,
    required this.isFilled,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Неделя $weekNumber',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isFilled ? 'Заполнено' : 'Не заполнено',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colors.hint,
          ),
        ),
      ],
    );
  }
}