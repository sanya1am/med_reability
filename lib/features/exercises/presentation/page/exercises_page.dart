import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/features/exercises/presentation/page/exercise_details_page.dart';
import 'package:med_reability/features/exercises/presentation/page/exercise_form_page.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import '../../../../utils/widgets/app_text_field.dart';
import '../../../../utils/widgets/primary_button.dart';
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

        final q = _search.text.trim().toLowerCase();
        final items = q.isEmpty
            ? allItems
            : allItems.where((x) => x.name.toLowerCase().contains(q)).toList();

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
                  onTap: () {
                    // фильтр потом добавишь сюда
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
                  onTap: () async {
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