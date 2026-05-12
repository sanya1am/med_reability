import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/features/patient/presentation/view_model/patient_program_overview_view_model.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';

import '../state/patient_well_being_form_state.dart';
import '../view_model/patient_well_being_form_view_model.dart';

class PatientWellBeingFormPage extends ConsumerStatefulWidget {
  final String planId;
  final int dayNumber;

  const PatientWellBeingFormPage({
    super.key,
    required this.planId,
    required this.dayNumber,
  });

  @override
  ConsumerState<PatientWellBeingFormPage> createState() =>
      _PatientWellBeingFormPageState();
}

class _PatientWellBeingFormPageState
    extends ConsumerState<PatientWellBeingFormPage> {
  double wellBeingRating = 1;
  double difficultyRating = 1;
  bool hadPain = false;
  double painIntensityRating = 1;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final args = PatientWellBeingFormArgs(
      planId: widget.planId,
      dayNumber: widget.dayNumber,
    );

    final formState = ref.watch(patientWellBeingFormViewModelProvider(args));
    final vm = ref.read(patientWellBeingFormViewModelProvider(args).notifier);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 12, 28, 32),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Оценка самочувствия',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),

                        const SizedBox(height: 24),

                        _RatingQuestionCard(
                          number: 1,
                          title: 'Как вы себя чувствуете после тренировки?',
                          value: formState.wellBeingRating.toDouble(),
                          onChanged: (value) {
                            vm.setWellBeingRating(value.round());
                          },
                        ),

                        const SizedBox(height: 16),

                        _RatingQuestionCard(
                          number: 2,
                          title: 'Насколько сложной была тренировка?',
                          value: formState.workoutDifficultyRating.toDouble(),
                          onChanged: (value) {
                            vm.setWorkoutDifficultyRating(value.round());
                          },
                        ),

                        const SizedBox(height: 16),

                        _PainQuestionCard(
                          number: 3,
                          hadPain: formState.hadPain,
                          onChanged: vm.setHadPain,
                        ),

                        const SizedBox(height: 16),

                        _RatingQuestionCard(
                          number: 4,
                          title: 'Насколько сильная?',
                          value: formState.painIntensityRating.toDouble(),
                          enabled: formState.hadPain,
                          onChanged: (value) {
                            vm.setPainIntensityRating(value.round());
                          },
                        ),

                        const SizedBox(height: 28),

                        PrimaryButton(
                          text: 'Завершить',
                          onPressed: formState.isSubmitting
                              ? null
                              : () async {
                            final success = await vm.submit();

                            if (!context.mounted) return;

                            if (success) {
                              Navigator.of(context).pop(true);
                              return;
                            }

                            final error = ref
                                .read(patientWellBeingFormViewModelProvider(args))
                                .errorMessage;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  error ?? 'Не удалось сохранить оценку самочувствия',
                                ),
                              ),
                            );
                          },
                          loading: formState.isSubmitting,
                          height: 40,
                          textStyle: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RatingQuestionCard extends StatelessWidget {
  final int number;
  final String title;
  final double value;
  final bool enabled;
  final ValueChanged<double> onChanged;

  const _RatingQuestionCard({
    required this.number,
    required this.title,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _QuestionNumber(number: number),
          const SizedBox(width: 12),
          Expanded(
            child: Opacity(
              opacity: enabled ? 1 : 0.45,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 16),
                  _RatingScale(
                    value: value,
                    enabled: enabled,
                    onChanged: onChanged,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PainQuestionCard extends StatelessWidget {
  final int number;
  final bool hadPain;
  final ValueChanged<bool> onChanged;

  const _PainQuestionCard({
    required this.number,
    required this.hadPain,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _QuestionNumber(number: number),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Была ли боль или дискомфорт?',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 14),
                _RadioRow(
                  title: 'Да',
                  selected: hadPain,
                  onTap: () => onChanged(true),
                ),
                const SizedBox(height: 4),
                _RadioRow(
                  title: 'Нет',
                  selected: !hadPain,
                  onTap: () => onChanged(false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionNumber extends StatelessWidget {
  final int number;

  const _QuestionNumber({
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Text(
        number.toString(),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _RadioRow extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _RadioRow({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? primary : colors.border,
                width: 3,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingScale extends StatelessWidget {
  final double value;
  final bool enabled;
  final ValueChanged<double> onChanged;

  const _RatingScale({
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final primary = Theme.of(context).colorScheme.primary;

    const thumbSize = 18.0;
    const trackHeight = 3.0;
    const scaleHorizontalPadding = thumbSize / 2;

    final currentValue = value.clamp(1, 10).round();

    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final fullWidth = constraints.maxWidth;
          final trackWidth = fullWidth - scaleHorizontalPadding * 2;
          final progress = (currentValue - 1) / 9;
          final thumbLeft = scaleHorizontalPadding + trackWidth * progress - thumbSize / 2;

          void updateByLocalDx(double dx) {
            if (!enabled) return;

            final clampedDx = (dx - scaleHorizontalPadding).clamp(0.0, trackWidth);
            final next = 1 + (clampedDx / trackWidth * 9).round();

            onChanged(next.toDouble());
          }

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) {
              updateByLocalDx(details.localPosition.dx);
            },
            onHorizontalDragUpdate: (details) {
              updateByLocalDx(details.localPosition.dx);
            },
            child: SizedBox(
              height: 54,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: scaleHorizontalPadding,
                    right: scaleHorizontalPadding,
                    top: 16,
                    child: Container(
                      height: trackHeight,
                      decoration: BoxDecoration(
                        color: colors.border,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  Positioned(
                    left: scaleHorizontalPadding,
                    top: 16,
                    child: Container(
                      width: trackWidth * progress,
                      height: trackHeight,
                      decoration: BoxDecoration(
                        color: enabled ? primary : colors.border,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  Positioned(
                    left: thumbLeft,
                    top: 16 - thumbSize / 2 + trackHeight / 2,
                    child: Container(
                      width: thumbSize,
                      height: thumbSize,
                      decoration: BoxDecoration(
                        color: enabled ? primary : colors.border,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  ...List.generate(10, (index) {
                    final number = index + 1;
                    final x = scaleHorizontalPadding + trackWidth * (index / 9);

                    return Positioned(
                      left: x - 8,
                      top: 34,
                      width: 16,
                      child: Text(
                        number.toString(),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: enabled
                              ? colors.textPrimary
                              : colors.textSecondary,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}