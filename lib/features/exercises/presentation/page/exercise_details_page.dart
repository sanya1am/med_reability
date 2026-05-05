import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise_type.dart';
import 'package:med_reability/features/exercises/presentation/widgets/exercise_instruction_card.dart';
import 'package:med_reability/features/exercises/presentation/widgets/exercise_media_slider.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_secondary_button.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';

import '../../domain/entities/exercise.dart';
import '../view_model/exercises_view_model.dart';
import '../../../../utils/widgets/app_top_actions_bar.dart';
import 'exercise_form_page.dart';

class ExerciseDetailsPage extends ConsumerStatefulWidget {
  final String exerciseId;

  const ExerciseDetailsPage({
    super.key,
    required this.exerciseId,
  });

  @override
  ConsumerState<ExerciseDetailsPage> createState() => _ExerciseDetailsPageState();
}

class _ExerciseDetailsPageState extends ConsumerState<ExerciseDetailsPage> {
  Exercise? exercise;
  bool isLoading = true;
  String? errorText;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      isLoading = true;
      errorText = null;
    });

    try {
      final result = await ref
          .read(exercisesViewModelProvider.notifier)
          .loadExerciseById(widget.exerciseId);

      if (!mounted) return;

      if (result == null) {
        setState(() {
          errorText = 'Не удалось загрузить упражнение';
          isLoading = false;
        });
        return;
      }

      setState(() {
        exercise = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorText = 'Ошибка: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _openEdit() async {
    if (exercise == null) return;

    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ExerciseFormPage(initialExercise: exercise),
      ),
    );

    if (changed == true) {
      await _load();
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    }
  }

  Future<void> _deleteExercise() async {
    if (exercise == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Удалить упражнение?'),
          content: const Text(
            'Это действие нельзя будет отменить.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await ref
        .read(exercisesViewModelProvider.notifier)
        .removeExercise(exercise!.id);

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;

    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorText != null
            ? Center(
          child: Text(
            errorText!,
            style: textTheme.bodyMedium?.copyWith(
              color: colors.textPrimary,
            ),
          ),
        )
            : RefreshIndicator(
          onRefresh: _load,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(28, 12, 28, 24),
            children: [
              AppTopActionsBar(
                onBack: () => Navigator.pop(context),
                onNotify: () {},
              ),
              const SizedBox(height: 16),

              ExerciseMediaSlider(mediaUrls: exercise!.mediaUrls),
              const SizedBox(height: 16),

              Text(
                exercise!.name,
                style: textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),

              Container(
                width: double.infinity,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                    exerciseTypeLabel(exercise!.type),
                    style: textTheme.titleSmall
                ),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black.withOpacity(0.18)
                          : const Color(0x22000000),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Описание', style: textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      exercise!.description,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Text('Инструкция', style: textTheme.titleMedium),
              const SizedBox(height: 12),

              ...List.generate(exercise!.steps.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ExerciseInstructionCard(
                    number: index + 1,
                    text: exercise!.steps[index],
                  ),
                );
              }),

              const SizedBox(height: 16),

              // PrimaryButton(
              //   text: 'Редактировать',
              //   onPressed: _openEdit,
              //   height: 38,
              //   textStyle: textTheme.titleSmall,
              // ),
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: 'Удалить',
                      onPressed: _deleteExercise,
                      height: 38,
                      textStyle: textTheme.titleSmall,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Редактировать',
                      onPressed: _openEdit,
                      height: 38,
                      textStyle: textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

