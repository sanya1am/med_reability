import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/state/rehabilitation_program_editor_state.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/view_model/rehabilitation_program_editor_view_model.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/widgets/day_editor/rehabilitation_delete_exercises_dialog.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_top_actions_bar.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';

class RehabilitationDayExerciseDeletePage extends ConsumerStatefulWidget {
  final RehabilitationProgramEditorArgs args;
  final int weekIndex;
  final int dayIndex;

  const RehabilitationDayExerciseDeletePage({
    super.key,
    required this.args,
    required this.weekIndex,
    required this.dayIndex,
  });

  @override
  ConsumerState<RehabilitationDayExerciseDeletePage> createState() =>
      _RehabilitationDayExerciseDeletePageState();
}

class _RehabilitationDayExerciseDeletePageState
    extends ConsumerState<RehabilitationDayExerciseDeletePage> {
  final selectedIndexes = <int>{};

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      rehabilitationProgramEditorViewModelProvider(widget.args),
    );

    final vm = ref.read(
      rehabilitationProgramEditorViewModelProvider(widget.args).notifier,
    );

    final day = state.weeks[widget.weekIndex].days[widget.dayIndex];

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            AppTopActionsBar(
              onBack: () => Navigator.pop(context),
              onNotify: () {},
            ),
            const SizedBox(height: 34),
            ...List.generate(day.exercises.length, (index) {
              final item = day.exercises[index];
              final selected = selectedIndexes.contains(index);

              return _DeleteExerciseTile(
                item: item,
                selected: selected,
                onTap: () {
                  setState(() {
                    if (selected) {
                      selectedIndexes.remove(index);
                    } else {
                      selectedIndexes.add(index);
                    }
                  });
                },
              );
            }),
            const SizedBox(height: 12),
            PrimaryButton(
              text: 'Удалить',
              onPressed: selectedIndexes.isEmpty
                  ? null
                  : () async {
                final confirmed =
                await showRehabilitationDeleteExercisesDialog(
                  context: context,
                );

                if (confirmed != true) return;

                final sorted = selectedIndexes.toList()
                  ..sort((a, b) => b.compareTo(a));

                for (final index in sorted) {
                  vm.removeExerciseFromDay(
                    weekIndex: widget.weekIndex,
                    dayIndex: widget.dayIndex,
                    exerciseIndex: index,
                  );
                }

                if (!context.mounted) return;
                Navigator.pop(context);
              },
              height: 38,
              textStyle: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _DeleteExerciseTile extends StatelessWidget {
  final RehabilitationProgramExerciseDraft item;
  final bool selected;
  final VoidCallback onTap;

  const _DeleteExerciseTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final primary = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.exerciseName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _metaText(item),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: selected ? primary : Colors.transparent,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(
                  color: primary,
                  width: 1,
                ),
              ),
              child: selected
                  ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 16,
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  String _metaText(RehabilitationProgramExerciseDraft item) {
    final parts = <String>[];

    if (item.sets > 0) parts.add('${item.sets} подхода');
    if (item.repetitions > 0) parts.add('${item.repetitions} повторений');
    if (item.durationSeconds > 0) parts.add('${item.durationSeconds} сек');
    if (item.restBetweenSetsInSeconds > 0) {
      parts.add('${item.restBetweenSetsInSeconds} сек отдых');
    }

    return parts.join(' · ');
  }
}