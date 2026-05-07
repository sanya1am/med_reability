import 'package:flutter/material.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise_filter_options.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise_filters.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise_type.dart';
import 'package:med_reability/features/exercises/presentation/widgets/exercise_card.dart';
import 'package:med_reability/features/exercises/presentation/widgets/filters/exercise_filters_sheet.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_text_field.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';

class ExerciseCatalogList extends StatefulWidget {
  final List<Exercise> items;
  final ExerciseFilterOptions filterOptions;
  final ExerciseFilters filters;
  final String? currentUserId;

  final String actionText;
  final ValueChanged<Exercise> onAction;

  final ValueChanged<ExerciseFilters> onApplyFilters;

  final bool showCreateButton;
  final VoidCallback? onCreate;

  final String emptyText;
  final String filteredEmptyText;

  const ExerciseCatalogList({
    super.key,
    required this.items,
    required this.filterOptions,
    required this.filters,
    required this.currentUserId,
    required this.actionText,
    required this.onAction,
    required this.onApplyFilters,
    this.showCreateButton = false,
    this.onCreate,
    this.emptyText = 'Вы не создали ни одного\nупражнения',
    this.filteredEmptyText = 'По выбранным фильтрам ничего не найдено',
  });

  @override
  State<ExerciseCatalogList> createState() => _ExerciseCatalogListState();
}

class _ExerciseCatalogListState extends State<ExerciseCatalogList> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final query = _search.text.trim().toLowerCase();

    final filteredItems = _filterExercises(
      allItems: widget.items,
      search: query,
      filters: widget.filters,
      currentUserId: widget.currentUserId,
    );

    if (widget.items.isEmpty) {
      return _EmptyState(
        text: widget.emptyText,
        showCreateButton: widget.showCreateButton,
        onCreate: widget.onCreate,
      );
    }

    return ListView(
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
            onTap: _openFilters,
            behavior: HitTestBehavior.opaque,
            child: Icon(
              Icons.tune,
              color: colors.textPrimary,
              size: 20,
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),

        const SizedBox(height: 24),

        if (filteredItems.isEmpty)
          _FilteredEmptyState(
            text: widget.filteredEmptyText,
          )
        else
          ...filteredItems.map(
                (exercise) {
              return ExerciseCard(
                exercise: exercise,
                actionText: widget.actionText,
                onAction: () => widget.onAction(exercise),
              );
            },
          ),

        if (widget.showCreateButton && widget.onCreate != null) ...[
          const SizedBox(height: 4),
          PrimaryButton(
            text: 'Создать',
            onPressed: widget.onCreate,
            height: 38,
            textStyle: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ],
    );
  }

  Future<void> _openFilters() async {
    final filters = await showExerciseFiltersSheet(
      context: context,
      options: widget.filterOptions,
      initialFilters: widget.filters,
    );

    if (filters == null) return;

    widget.onApplyFilters(filters);
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
}

class _EmptyState extends StatelessWidget {
  final String text;
  final bool showCreateButton;
  final VoidCallback? onCreate;

  const _EmptyState({
    required this.text,
    required this.showCreateButton,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
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
                      text,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    if (showCreateButton && onCreate != null) ...[
                      const SizedBox(height: 16),
                      PrimaryButton(
                        text: 'Создать',
                        onPressed: onCreate,
                        height: 38,
                        textStyle: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FilteredEmptyState extends StatelessWidget {
  final String text;

  const _FilteredEmptyState({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: colors.textPrimary,
          ),
        ),
      ),
    );
  }
}