import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/features/rehabilitation_plan/domain/entities/rehabilitation_program.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/page/rehabilitation_program_week_days_page.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/view_model/rehabilitation_program_editor_view_model.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/view_model/rehabilitation_program_templates_view_model.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/widgets/templates/rehabilitation_week_template_picker_dialog.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/widgets/rehabilitation_program_week_card.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_secondary_button.dart';
import 'package:med_reability/utils/widgets/app_top_actions_bar.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';

import '../state/rehabilitation_program_editor_state.dart';
import '../widgets/rehabilitation_program_delete_dialog.dart';
import '../widgets/rehabilitation_program_submit_dialog.dart';

class RehabilitationProgramWeeksPage extends ConsumerStatefulWidget {
  final String patientId;
  final RehabilitationProgram? initialProgram;

  const RehabilitationProgramWeeksPage({
    super.key,
    required this.patientId,
    this.initialProgram,
  });

  @override
  ConsumerState<RehabilitationProgramWeeksPage> createState() =>
      _RehabilitationProgramWeeksPageState();
}

class _RehabilitationProgramWeeksPageState
    extends ConsumerState<RehabilitationProgramWeeksPage> {
  late final RehabilitationProgramEditorArgs args;

  @override
  void initState() {
    super.initState();

    args = RehabilitationProgramEditorArgs(
      patientId: widget.patientId,
      initialProgram: widget.initialProgram,
    );
  }

  @override
  Widget build(BuildContext context) {
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

    final colors = context.appColors;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(28, 16, 28, 24),
          children: [
            AppTopActionsBar(onBack: () => Navigator.pop(context), onNotify: () {}),

            const SizedBox(height: 38),

            ...List.generate(editorState.weeks.length, (index) {
              final week = editorState.weeks[index];

              return RehabilitationProgramWeekCard(
                weekNumber: week.weekNumber,
                isFilled: week.isFilled,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RehabilitationProgramWeekDaysPage(
                        args: args,
                        weekIndex: index,
                      ),
                    ),
                  );
                },
                onSaveAsTemplate: () {
                  templatesVm.saveWeekTemplate(
                    name: 'Неделя ${week.weekNumber}',
                    days: week.days.map((day) => day.toEntity()).toList(),
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
                  if (templatesState.weekTemplates.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Нет сохранённых шаблонов недель'),
                      ),
                    );
                    return;
                  }

                  final template =
                  await showRehabilitationWeekTemplatePickerDialog(
                    context: context,
                    templates: templatesState.weekTemplates,
                    onDeleteTemplate: templatesVm.deleteWeekTemplate,
                  );

                  if (template == null) return;

                  editorVm.applyWeekTemplate(
                    targetWeekIndex: index,
                    template: template,
                  );
                },
                onDelete: () {
                  if (editorState.weeks.length == 1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Нельзя удалить последнюю неделю'),
                      ),
                    );
                    return;
                  }

                  editorVm.deleteWeek(index);
                },
              );
            }),

            const SizedBox(height: 4),

            SecondaryButton(
              text: 'Добавить неделю',
              onPressed: editorVm.addWeek,
              height: 38,
              textStyle: Theme.of(context).textTheme.titleSmall,
            ),

            const SizedBox(height: 12),

            PrimaryButton(
              text: editorState.isEdit ? 'Сохранить план' : 'Назначить план',
              onPressed: editorState.isSubmitting
                  ? null
                  : () => _submitPlan(
                context: context,
                ref: ref,
                editorState: editorState,
                editorVm: editorVm,
              ),
              height: 38,
              textStyle: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitPlan({
    required BuildContext context,
    required WidgetRef ref,
    required RehabilitationProgramEditorState editorState,
    required RehabilitationProgramEditorViewModel editorVm,
  }) async {
    if (editorState.isEdit && editorVm.isProgramEmpty) {
      final confirmed = await showRehabilitationProgramDeleteDialog(
        context: context,
      );

      if (confirmed != true) return;

      final success = await editorVm.deleteProgram();

      if (!context.mounted) return;

      if (success) {
        Navigator.of(context).pop(true);
        return;
      }

      final error = ref
          .read(
        rehabilitationProgramEditorViewModelProvider(args),
      )
          .errorMessage;

      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }

      return;
    }

    final startDate = await showRehabilitationProgramSubmitDialog(
      context: context,
      initialDate: editorState.startDate,
      isEdit: editorState.isEdit,
    );

    if (startDate == null) return;

    editorVm.setStartDate(startDate);

    final success = await editorVm.submit();

    if (!context.mounted) return;

    if (success) {
      Navigator.of(context).pop(true);
      return;
    }

    final error = ref
        .read(
      rehabilitationProgramEditorViewModelProvider(args),
    )
        .errorMessage;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }
}