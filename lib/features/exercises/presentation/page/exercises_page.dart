import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/features/auth/presentation/view_model/user_me_view_model.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise_type.dart';
import 'package:med_reability/features/exercises/presentation/page/exercise_details_page.dart';
import 'package:med_reability/features/exercises/presentation/page/exercise_form_page.dart';
import 'package:med_reability/features/exercises/presentation/widgets/filters/exercise_filters_sheet.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import '../../../../utils/widgets/app_text_field.dart';
import '../../../../utils/widgets/primary_button.dart';
import '../../domain/entities/exercise_filters.dart';
import '../view_model/exercises_view_model.dart';
import '../widgets/exercise_card.dart';


class ExercisesPage extends ConsumerStatefulWidget {
  const ExercisesPage({super.key});

  @override
  ConsumerState<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends ConsumerState<ExercisesPage> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _openCreate() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const ExerciseFormPage()),
    );
    if (created == true) {
      await ref.read(exercisesViewModelProvider.notifier).refresh();
    }
  }

  List<Exercise> _filterExercises({
    required List<Exercise> allItems,
    required String search,
    required ExerciseFilters filters,
    required String? currentUserId,
  }) {
    return allItems.where((exercise) {
      if (search.isNotEmpty &&
          !exercise.name.toLowerCase().contains(search) &&
          !exercise.description.toLowerCase().contains(search)) {
        return false;
      }

      switch (filters.access) {
        case ExerciseAccessFilter.all:
          break;

        case ExerciseAccessFilter.global:
          if (!exercise.isGlobal) return false;
          break;

        case ExerciseAccessFilter.mine:
          if (currentUserId == null || exercise.userId != currentUserId) {
            return false;
          }
          break;
      }

      if (filters.trackingTypes.isNotEmpty) {
        final apiType = exerciseTypeToApi(exercise.type);
        if (!filters.trackingTypes.contains(apiType)) {
          return false;
        }
      }

      if (filters.exerciseTypes.isNotEmpty &&
          !exercise.exerciseTypes.any(filters.exerciseTypes.contains)) {
        return false;
      }

      if (filters.bodyParts.isNotEmpty &&
          !exercise.bodyParts.any(filters.bodyParts.contains)) {
        return false;
      }

      if (filters.inventory.isNotEmpty &&
          !exercise.inventory.any(filters.inventory.contains)) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(exercisesViewModelProvider);
    final colors = context.appColors;

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(
          'Ошибка: $e',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colors.textPrimary,
          ),
        ),
      ),
      data: (s) {
        final allItems = s.items;

        if (allItems.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => ref.read(exercisesViewModelProvider.notifier).refresh(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 40,
                              color: colors.textPrimary,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Вы не создали ни одного\nупражнения',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: colors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            PrimaryButton(
                              text: 'Создать',
                              onPressed: _openCreate,
                              height: 38,
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
          );
        }

        final me = ref.watch(userMeViewModelProvider).valueOrNull;
        final q = _search.text.trim().toLowerCase();
        final items = _filterExercises(
          allItems: s.items,
          search: q,
          filters: s.filters,
          currentUserId: me?.userId,
        );

        return RefreshIndicator(
          onRefresh: () => ref.read(exercisesViewModelProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(28, 16, 28, 120),
            children: [
              AppTextField(
                hintText: 'Найти упражнение',
                controller: _search,
                prefixIcon: Icon(
                  Icons.search,
                  color: colors.hint,
                  size: 22,
                ),
                suffixIcon: GestureDetector(
                  onTap: () async {
                    final filters = await showExerciseFiltersSheet(
                      context: context,
                      options: s.filterOptions,
                      initialFilters: s.filters,
                    );

                    if (filters != null) {
                      ref.read(exercisesViewModelProvider.notifier).applyFilters(filters);
                    }
                  },
                  child: Icon(
                    Icons.tune,
                    color: colors.textPrimary,
                    size: 20,
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 24),

              ...items.map(
                    (x) => ExerciseCard(
                  exercise: x,
                  onDetailsTap: () async {
                    final changed = await Navigator.of(context).push<bool>(
                      MaterialPageRoute(
                        builder: (_) => ExerciseDetailsPage(exerciseId: x.id),
                      ),
                    );

                    if (changed == true) {
                      await ref.read(exercisesViewModelProvider.notifier).refresh();
                    }
                  },
                ),
              ),
              const SizedBox(height: 4),
              PrimaryButton(
                text: 'Создать',
                onPressed: _openCreate,
                height: 38,
                textStyle: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        );
      },
    );
  }
}