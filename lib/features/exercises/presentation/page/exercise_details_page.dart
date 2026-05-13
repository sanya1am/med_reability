import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_secondary_button.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';
import '../../../../core/router/app_route_names.dart';
import '../../../../utils/widgets/app_breadcrumbs.dart';
import '../../domain/entities/exercise.dart';
import '../view_model/exercises_view_model.dart';
import '../../../../utils/widgets/app_top_actions_bar.dart';
import '../widgets/exercise_details_content.dart';
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
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;

    if (isLoading) {
      return const Scaffold(
        body: SafeArea(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (errorText != null || exercise == null) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
            child: Column(
              children: [
                AppTopActionsBar(
                  onBack: () => Navigator.pop(context),
                  onNotify: () {},
                ),
                const SizedBox(height: 40),
                Text(
                  errorText ?? 'Не удалось загрузить упражнение',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final currentExercise = exercise!;

    Widget bottomActions() {
      return Row(
        children: [
          Expanded(
            child: SecondaryButton(
              text: 'Удалить',
              onPressed: _deleteExercise,
              height: 38,
              textStyle: textTheme.titleSmall,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: PrimaryButton(
              text: 'Редактировать',
              onPressed: _openEdit,
              height: 38,
              textStyle: textTheme.titleSmall,
            ),
          ),
        ],
      );
    }

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;

            if (isDesktop) {
              return ListView(
                padding: const EdgeInsets.fromLTRB(28, 20, 28, 32),
                children: [
                  AppBreadcrumbs(
                    onBack: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.goNamed(AppRouteNames.doctorExercises);
                      }
                    },
                    items: [
                      AppBreadcrumbItem(
                        label: 'Упражнения',
                        onTap: () {
                          context.goNamed(AppRouteNames.doctorExercises);
                        },
                      ),
                      AppBreadcrumbItem(
                        label: currentExercise.name,
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  ExerciseDetailsContent(
                    exercise: currentExercise,
                    isDesktopLayout: true,
                    bottomActions: bottomActions(),
                  ),
                ],
              );
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
              children: [
                AppTopActionsBar(
                  onBack: () => Navigator.pop(context),
                  onNotify: () {},
                ),
                const SizedBox(height: 16),
                ExerciseDetailsContent(
                  exercise: currentExercise,
                  bottomActions: bottomActions(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

