import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/features/exercises/presentation/widgets/exercise_assignment_meta_card.dart';
import 'package:med_reability/features/exercises/presentation/widgets/exercise_details_content.dart';
import 'package:med_reability/features/patient/domain/entities/patient_workout_exercise.dart';
import 'package:med_reability/features/patient/presentation/page/patient_workout_finished_page.dart';
import 'package:med_reability/features/patient/presentation/view_model/patient_program_overview_view_model.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_top_actions_bar.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';

class PatientWorkoutExecutionPage extends ConsumerStatefulWidget {
  final List<PatientWorkoutExercise> initialExercises;
  final String planId;
  final int dayNumber;

  const PatientWorkoutExecutionPage({
    super.key,
    required this.initialExercises,
    required this.planId,
    required this.dayNumber,
  });

  @override
  ConsumerState<PatientWorkoutExecutionPage> createState() =>
      _PatientWorkoutExecutionPageState();
}

class _PatientWorkoutExecutionPageState
    extends ConsumerState<PatientWorkoutExecutionPage> {
  int _index = 0;
  bool _markAsCompleted = false;
  bool _loading = false;

  final Set<String> _completedInSession = {};

  List<PatientWorkoutExercise> get _sortedExercises {
    final sorted = [...widget.initialExercises]
      ..sort((a, b) => a.order.compareTo(b.order));

    return sorted;
  }

  PatientWorkoutExercise get _current => _sortedExercises[_index];

  bool get _isLastExercise => _index >= _sortedExercises.length - 1;

  @override
  void initState() {
    super.initState();

    if (widget.initialExercises.isNotEmpty) {
      final first = _sortedExercises.first;
      _markAsCompleted = first.isCompleted;
    }
  }

  Future<void> _goNext() async {
    if (_loading) return;

    setState(() {
      _loading = true;
    });

    final vm = ref.read(patientProgramOverviewViewModelProvider.notifier);
    final current = _current;

    if (_markAsCompleted &&
        !current.isCompleted &&
        !_completedInSession.contains(current.dayExerciseId)) {
      final success = await vm.completeExercise(
        dayExerciseId: current.dayExerciseId,
      );

      if (!mounted) return;

      if (!success) {
        setState(() {
          _loading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Не удалось отметить упражнение выполненным'),
          ),
        );

        return;
      }

      _completedInSession.add(current.dayExerciseId);
    }

    if (_isLastExercise) {
      final success = await vm.completeSelectedDay();

      if (!mounted) return;

      if (!success) {
        setState(() {
          _loading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Не удалось завершить тренировку'),
          ),
        );

        return;
      }

      final changed = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => PatientWorkoutFinishedPage(
            planId: widget.planId,
            dayNumber: widget.dayNumber,
          ),
        ),
      );

      if (!mounted) return;

      Navigator.of(context).pop(changed == true);
      return;
    }

    setState(() {
      _index++;
      _markAsCompleted = _current.isCompleted ||
          _completedInSession.contains(_current.dayExerciseId);
      _loading = false;
    });
  }

  void _goBack() {
    if (_index == 0) {
      Navigator.of(context).pop(false);
      return;
    }

    setState(() {
      _index--;
      _markAsCompleted = _current.isCompleted ||
          _completedInSession.contains(_current.dayExerciseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (widget.initialExercises.isEmpty) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Text(
              'На сегодня нет упражнений',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
        ),
      );
    }

    final item = _current;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(28, 12, 28, 32),
          children: [
            AppTopActionsBar(
              onBack: _goBack,
              onNotify: () {},
            ),

            const SizedBox(height: 20),

            ExerciseDetailsContent(
              exercise: item.exercise,
              showTypePill: false,
              afterTitle: ExerciseAssignmentMetaCard(
                sets: item.sets,
                repetitions: item.repetitions,
                durationSeconds: item.durationSeconds,
                restBetweenSetsInSeconds: item.restBetweenSetsInSeconds,
              ),
              bottomActions: Column(
                children: [
                  _CompletedCheckbox(
                    value: _markAsCompleted,
                    onChanged: (value) {
                      setState(() {
                        _markAsCompleted = value;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  PrimaryButton(
                    text: _isLastExercise
                        ? 'Завершить тренировку'
                        : 'К следующему упражнению',
                    onPressed: _loading ? null : _goNext,
                    loading: _loading,
                    height: 38,
                    textStyle: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompletedCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _CompletedCheckbox({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final primary = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: primary,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: Checkbox(
                value: value,
                onChanged: (v) => onChanged(v ?? false),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                side: BorderSide(color: primary),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'Отметить как выполненное',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}