import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/features/auth/presentation/view_model/user_me_view_model.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise_filters.dart';
import 'package:med_reability/features/exercises/presentation/widgets/exercise_catalog_list.dart';
import 'package:med_reability/features/exercises/presentation/view_model/exercises_view_model.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/page/rehabilitation_exercise_details_page.dart';
import 'package:med_reability/features/rehabilitation_plan/presentation/state/rehabilitation_program_editor_state.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

import '../../../../utils/widgets/app_top_actions_bar.dart';

class RehabilitationExercisePickerPage extends ConsumerStatefulWidget {
  const RehabilitationExercisePickerPage({
    super.key,
  });

  @override
  ConsumerState<RehabilitationExercisePickerPage> createState() =>
      _RehabilitationExercisePickerPageState();
}

class _RehabilitationExercisePickerPageState
    extends ConsumerState<RehabilitationExercisePickerPage> {
  ExerciseFilters filters = const ExerciseFilters();

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(exercisesViewModelProvider);
    final me = ref.watch(userMeViewModelProvider).valueOrNull;
    final colors = context.appColors;

    return Scaffold(
      body: SafeArea(
        child: async.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Text(
                'Ошибка: $error',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ),
          ),
          data: (state) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: AppTopActionsBar(onBack: () => Navigator.pop(context), onNotify: () {}),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () {
                      return ref
                          .read(exercisesViewModelProvider.notifier)
                          .refresh();
                    },
                    child: ExerciseCatalogList(
                      items: state.items,
                      filterOptions: state.filterOptions,
                      filters: filters,
                      currentUserId: me?.userId,
                      actionText: 'Выбрать',
                      onAction: (exercise) async {
                        final draft =
                        await Navigator.of(context).push<
                            RehabilitationProgramExerciseDraft>(
                          MaterialPageRoute(
                            builder: (_) => RehabilitationExerciseDetailsPage(
                              exercise: exercise,
                            ),
                          ),
                        );

                        if (draft == null) return;
                        if (!context.mounted) return;

                        Navigator.of(context).pop(draft);
                      },
                      onApplyFilters: (nextFilters) {
                        setState(() {
                          filters = nextFilters;
                        });
                      },
                      showCreateButton: false,
                      emptyText: 'Нет доступных упражнений',
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
