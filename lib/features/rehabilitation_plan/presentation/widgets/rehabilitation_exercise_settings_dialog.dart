import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise_type.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/state/rehabilitation_program_editor_state.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_secondary_button.dart';
import 'package:med_reability/utils/widgets/app_text_field.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';

Future<RehabilitationProgramExerciseDraft?>
showRehabilitationExerciseSettingsDialog({
  required BuildContext context,
  required Exercise exercise,
  RehabilitationProgramExerciseDraft? initialValue,
}) {
  return showDialog<RehabilitationProgramExerciseDraft>(
    context: context,
    barrierColor: Colors.black.withOpacity(0.12),
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5,
          sigmaY: 5,
        ),
        child: _RehabilitationExerciseSettingsDialog(
          exercise: exercise,
          initialValue: initialValue,
        ),
      );
    },
  );
}

class _RehabilitationExerciseSettingsDialog extends StatefulWidget {
  final Exercise exercise;
  final RehabilitationProgramExerciseDraft? initialValue;

  const _RehabilitationExerciseSettingsDialog({
    required this.exercise,
    this.initialValue,
  });

  @override
  State<_RehabilitationExerciseSettingsDialog> createState() =>
      _RehabilitationExerciseSettingsDialogState();
}

class _RehabilitationExerciseSettingsDialogState
    extends State<_RehabilitationExerciseSettingsDialog> {
  final setsCtrl = TextEditingController();
  final repetitionsCtrl = TextEditingController();
  final durationCtrl = TextEditingController();
  final restCtrl = TextEditingController();

  String? errorText;

  @override
  void initState() {
    super.initState();

    final initial = widget.initialValue;

    setsCtrl.text = (initial?.sets ?? 1).toString();

    if (widget.exercise.type == ExerciseType.repetition) {
      repetitionsCtrl.text = initial?.repetitions == null || initial!.repetitions <= 0
          ? ''
          : initial.repetitions.toString();
    } else {
      durationCtrl.text = initial?.durationSeconds == null || initial!.durationSeconds <= 0
          ? ''
          : initial.durationSeconds.toString();
    }

    restCtrl.text = initial?.restBetweenSetsInSeconds == null ||
        initial!.restBetweenSetsInSeconds <= 0
        ? ''
        : initial.restBetweenSetsInSeconds.toString();
  }

  @override
  void dispose() {
    setsCtrl.dispose();
    repetitionsCtrl.dispose();
    durationCtrl.dispose();
    restCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isRepetition = widget.exercise.type == ExerciseType.repetition;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
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
              'Настроить упражнение',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 22),

            _FieldBlock(
              label: 'Количество подходов',
              child: AppTextField(
                hintText: 'Введите количество подходов',
                controller: setsCtrl,
                keyboardType: TextInputType.number,
              ),
            ),

            const SizedBox(height: 14),

            if (isRepetition)
              _FieldBlock(
                label: 'Количество повторений',
                child: AppTextField(
                  hintText: 'Введите количество повторений',
                  controller: repetitionsCtrl,
                  keyboardType: TextInputType.number,
                ),
              )
            else
              _FieldBlock(
                label: 'Время выполнения',
                child: AppTextField(
                  hintText: 'Введите время в секундах',
                  controller: durationCtrl,
                  keyboardType: TextInputType.number,
                ),
              ),

            const SizedBox(height: 14),

            _FieldBlock(
              label: 'Отдых между подходами (необязательно)',
              child: AppTextField(
                hintText: 'Введите время отдыха',
                controller: restCtrl,
                keyboardType: TextInputType.number,
              ),
            ),

            if (errorText != null) ...[
              const SizedBox(height: 12),
              Text(
                errorText!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ],

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: 'Отмена',
                    onPressed: () => Navigator.of(context).pop(),
                    height: 38,
                    textStyle: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    text: 'Сохранить',
                    onPressed: _save,
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

  void _save() {
    final sets = int.tryParse(setsCtrl.text.trim()) ?? 0;
    final repetitions = int.tryParse(repetitionsCtrl.text.trim()) ?? 0;
    final durationSeconds = int.tryParse(durationCtrl.text.trim()) ?? 0;
    final restSeconds = int.tryParse(restCtrl.text.trim()) ?? 0;

    if (sets <= 0) {
      setState(() {
        errorText = 'Введите количество подходов';
      });
      return;
    }

    if (widget.exercise.type == ExerciseType.repetition && repetitions <= 0) {
      setState(() {
        errorText = 'Введите количество повторений';
      });
      return;
    }

    if (widget.exercise.type == ExerciseType.time && durationSeconds <= 0) {
      setState(() {
        errorText = 'Введите время выполнения';
      });
      return;
    }

    final draft = RehabilitationProgramExerciseDraft(
      id: widget.initialValue?.id,
      exerciseId: widget.exercise.id,
      exerciseName: widget.exercise.name,
      exercise: widget.exercise,
      sets: sets,
      restBetweenSetsInSeconds: restSeconds,
      restAfterInSeconds: 0,
      repetitions: widget.exercise.type == ExerciseType.repetition ? repetitions : 0,
      durationSeconds: widget.exercise.type == ExerciseType.time ? durationSeconds : 0,
      comment: widget.initialValue?.comment,
    );

    Navigator.of(context).pop(draft);
  }
}

class _FieldBlock extends StatelessWidget {
  final String label;
  final Widget child;

  const _FieldBlock({
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}