import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

enum RehabilitationProgramDayMenuAction {
  saveAsTemplate,
  fillFromTemplate,
  clear,
}

class RehabilitationProgramDayCard extends StatelessWidget {
  final int dayNumber;
  final bool isRestDay;
  final int exercisesCount;
  final bool hasNotes;
  final VoidCallback onTap;
  final VoidCallback onSaveAsTemplate;
  final VoidCallback onFillFromTemplate;
  final VoidCallback onClear;

  const RehabilitationProgramDayCard({
    super.key,
    required this.dayNumber,
    required this.isRestDay,
    required this.exercisesCount,
    required this.hasNotes,
    required this.onTap,
    required this.onSaveAsTemplate,
    required this.onFillFromTemplate,
    required this.onClear,
  });

  bool get isFilled {
    return isRestDay || exercisesCount > 0 || hasNotes;
  }

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
                child: _DayTextBlock(
                  dayNumber: dayNumber,
                  subtitle: _subtitle(),
                ),
              ),
              PopupMenuButton<RehabilitationProgramDayMenuAction>(
                color: colors.surface,
                surfaceTintColor: Colors.transparent,
                elevation: 4,
                icon: Icon(
                  Icons.more_vert,
                  color: colors.textPrimary,
                ),
                onSelected: (action) {
                  switch (action) {
                    case RehabilitationProgramDayMenuAction.saveAsTemplate:
                      onSaveAsTemplate();
                      break;

                    case RehabilitationProgramDayMenuAction.fillFromTemplate:
                      onFillFromTemplate();
                      break;

                    case RehabilitationProgramDayMenuAction.clear:
                      onClear();
                      break;
                  }
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: RehabilitationProgramDayMenuAction.saveAsTemplate,
                      child: Text(
                        'Сохранить как шаблон',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    PopupMenuItem(
                      value: RehabilitationProgramDayMenuAction.fillFromTemplate,
                      child: Text(
                        'Заполнить шаблоном',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    PopupMenuItem(
                      value: RehabilitationProgramDayMenuAction.clear,
                      child: Text(
                        'Очистить',
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

  String _subtitle() {
    if (isRestDay) {
      return 'День отдыха';
    }

    if (exercisesCount > 0) {
      return _formatExercisesCount(exercisesCount);
    }

    if (hasNotes) {
      return 'Есть заметка';
    }

    return 'Не заполнено';
  }

  String _formatExercisesCount(int count) {
    final mod10 = count % 10;
    final mod100 = count % 100;

    if (mod10 == 1 && mod100 != 11) {
      return '$count упражнение';
    }

    if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) {
      return '$count упражнения';
    }

    return '$count упражнений';
  }
}

class _DayTextBlock extends StatelessWidget {
  final int dayNumber;
  final String subtitle;

  const _DayTextBlock({
    required this.dayNumber,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'День $dayNumber',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colors.hint,
          ),
        ),
      ],
    );
  }
}