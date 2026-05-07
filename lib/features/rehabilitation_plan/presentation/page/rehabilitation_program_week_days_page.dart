import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/page/rehabilitation_program_day_editor_page.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/view_model/rehabilitation_program_editor_view_model.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/view_model/rehabilitation_program_templates_view_model.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/widgets/rehabilitation_program_day_card.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/widgets/templates/rehabilitation_day_template_picker_dialog.dart';
import '../../../../utils/widgets/app_top_actions_bar.dart';
import '../widgets/rehabilitation_plan_switcher.dart';


class RehabilitationProgramWeekDaysPage extends ConsumerWidget {
  final RehabilitationProgramEditorArgs args;
  final int weekIndex;

  const RehabilitationProgramWeekDaysPage({
    super.key,
    required this.args,
    required this.weekIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorState = ref.watch(
      rehabilitationProgramEditorViewModelProvider(args),
    );

    final templatesState = ref.watch(
      rehabilitationProgramTemplatesViewModelProvider(args.scopeId),
    );

    final editorVm = ref.read(
      rehabilitationProgramEditorViewModelProvider(args).notifier,
    );

    final templatesVm = ref.read(
      rehabilitationProgramTemplatesViewModelProvider(args.scopeId).notifier,
    );

    if (weekIndex < 0 || weekIndex >= editorState.weeks.length) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Text(
              'Неделя не найдена',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      );
    }

    final week = editorState.weeks[weekIndex];

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(28, 16, 28, 24),
          children: [
            AppTopActionsBar(onBack: () => Navigator.pop(context), onNotify: () {}),

            const SizedBox(height: 34),

            RehabilitationPlanSwitcher(
              title: 'Неделя ${weekIndex + 1}',
              canGoPrevious: weekIndex  > 0,
              canGoNext: weekIndex  < editorState.weeks.length - 1,
              onPrevious: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => RehabilitationProgramWeekDaysPage(
                      args: args,
                      weekIndex: weekIndex - 1,
                    ),
                  ),
                );
              },
              onNext: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => RehabilitationProgramWeekDaysPage(
                      args: args,
                      weekIndex: weekIndex  + 1,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            ...List.generate(week.days.length, (dayIndex) {
              final day = week.days[dayIndex];

              return RehabilitationProgramDayCard(
                dayNumber: day.dayNumber,
                isRestDay: day.isRestDay,
                exercisesCount: day.exercises.length,
                hasNotes: day.notes != null && day.notes!.trim().isNotEmpty,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RehabilitationProgramDayEditorPage(
                        args: args,
                        weekIndex: weekIndex,
                        dayIndex: dayIndex,
                      ),
                    ),
                  );
                },
                onSaveAsTemplate: () {
                  templatesVm.saveDayTemplate(
                    name: 'День ${day.dayNumber}',
                    day: day.toEntity(),
                  );

                  final error = ref
                      .read(
                    rehabilitationProgramTemplatesViewModelProvider(
                      args.scopeId,
                    ),
                  )
                      .errorMessage;

                  if (error != null && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error)),
                    );

                    templatesVm.clearError();
                  }
                },
                onFillFromTemplate: () async {
                  if (templatesState.dayTemplates.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Нет сохранённых шаблонов дней'),
                      ),
                    );
                    return;
                  }

                  final template =
                  await showRehabilitationDayTemplatePickerDialog(
                    context: context,
                    templates: templatesState.dayTemplates,
                    onDeleteTemplate: templatesVm.deleteDayTemplate,
                  );

                  if (template == null) return;

                  editorVm.applyDayTemplate(
                    weekIndex: weekIndex,
                    dayIndex: dayIndex,
                    template: template,
                  );
                },
                onClear: () {
                  editorVm.clearDay(
                    weekIndex: weekIndex,
                    dayIndex: dayIndex,
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}