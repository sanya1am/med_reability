import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reability/core/router/app_route_names.dart';
import 'package:med_reability/features/auth/presentation/view_model/user_me_view_model.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise_type.dart';
import 'package:med_reability/features/exercises/presentation/page/exercise_details_page.dart';
import 'package:med_reability/features/exercises/presentation/page/exercise_form_page.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import '../../domain/entities/exercise_filters.dart';
import '../view_model/exercises_view_model.dart';
import '../widgets/exercise_catalog_list.dart';


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
        final me = ref.watch(userMeViewModelProvider).valueOrNull;

        return RefreshIndicator(
          onRefresh: () => ref
              .read(exercisesViewModelProvider.notifier)
              .refresh(),
          child: ExerciseCatalogList(
            items: s.items,
            filterOptions: s.filterOptions,
            filters: s.filters,
            currentUserId: me?.userId,
            actionText: 'Подробнее',
            onAction: (exercise) async {
              final changed = await
              context.pushNamed(
                AppRouteNames.doctorExerciseDetails,
                pathParameters: {
                  'exerciseId': exercise.id,
                },
              );
              // Navigator.of(context).push<bool>(
              //   MaterialPageRoute(
              //     builder: (_) => ExerciseDetailsPage(
              //       exerciseId: exercise.id,
              //     ),
              //   ),
              // );

              if (changed == true) {
                await ref
                    .read(exercisesViewModelProvider.notifier)
                    .refresh();
              }
            },
            onApplyFilters: (filters) {
              ref
                  .read(exercisesViewModelProvider.notifier)
                  .applyFilters(filters);
            },
            showCreateButton: true,
            onCreate: _openCreate,
          ),
        );
      },
    );
  }
}