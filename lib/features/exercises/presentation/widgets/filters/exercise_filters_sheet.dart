import 'package:flutter/material.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise_filter_options.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise_filters.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise_type.dart';
import 'package:med_reability/features/exercises/presentation/widgets/filters/exercise_access_filter_section.dart';
import 'package:med_reability/features/exercises/presentation/widgets/filters/exercise_filter_chip_section.dart';
import 'package:med_reability/features/exercises/presentation/widgets/filters/exercise_filters_header.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';

Future<ExerciseFilters?> showExerciseFiltersSheet({
  required BuildContext context,
  required ExerciseFilterOptions options,
  required ExerciseFilters initialFilters,
}) {
  return showModalBottomSheet<ExerciseFilters>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return ExerciseFiltersSheet(
        options: options,
        initialFilters: initialFilters,
      );
    },
  );
}

class ExerciseFiltersSheet extends StatefulWidget {
  final ExerciseFilterOptions options;
  final ExerciseFilters initialFilters;

  const ExerciseFiltersSheet({
    super.key,
    required this.options,
    required this.initialFilters,
  });

  @override
  State<ExerciseFiltersSheet> createState() => _ExerciseFiltersSheetState();
}

class _ExerciseFiltersSheetState extends State<ExerciseFiltersSheet> {
  late ExerciseAccessFilter _access;
  late List<String> _trackingTypes;
  late List<String> _exerciseTypes;
  late List<String> _bodyParts;
  late List<String> _inventory;

  @override
  void initState() {
    super.initState();

    _access = widget.initialFilters.access;
    _trackingTypes = List.of(widget.initialFilters.trackingTypes);
    _exerciseTypes = List.of(widget.initialFilters.exerciseTypes);
    _bodyParts = List.of(widget.initialFilters.bodyParts);
    _inventory = List.of(widget.initialFilters.inventory);
  }

  void _apply() {
    Navigator.of(context).pop(
      ExerciseFilters(
        access: _access,
        trackingTypes: _trackingTypes,
        exerciseTypes: _exerciseTypes,
        bodyParts: _bodyParts,
        inventory: _inventory,
      ),
    );
  }

  void _reset() {
    setState(() {
      _access = ExerciseAccessFilter.all;
      _trackingTypes = [];
      _exerciseTypes = [];
      _bodyParts = [];
      _inventory = [];
    });
  }

  void _toggleValue({
    required String value,
    required List<String> selectedValues,
    required ValueChanged<List<String>> onChanged,
  }) {
    final next = List<String>.of(selectedValues);

    if (next.contains(value)) {
      next.remove(value);
    } else {
      next.add(value);
    }

    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final maxHeight = MediaQuery.of(context).size.height * 0.94;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: maxHeight,
          ),
          decoration: BoxDecoration(
            color: colors.dialogBackground,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 24,
                offset: const Offset(0, -8),
                color: colors.dialogShadow,
              ),
            ],
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExerciseFiltersHeader(
                  onReset: _reset,
                ),

                const SizedBox(height: 18),

                ExerciseAccessFilterSection(
                  value: _access,
                  onChanged: (value) {
                    setState(() {
                      _access = value;
                    });
                  },
                ),

                if (widget.options.trackingTypes.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  ExerciseFilterChipSection(
                    title: 'Тип выполнения',
                    values: widget.options.trackingTypes,
                    selectedValues: _trackingTypes,
                    labelBuilder: _trackingTypeLabel,
                    onToggle: (value) {
                      _toggleValue(
                        value: value,
                        selectedValues: _trackingTypes,
                        onChanged: (next) {
                          setState(() {
                            _trackingTypes = next;
                          });
                        },
                      );
                    },
                  ),
                ],

                if (widget.options.bodyParts.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  ExerciseFilterChipSection(
                    title: 'Часть тела',
                    values: widget.options.bodyParts,
                    selectedValues: _bodyParts,
                    onToggle: (value) {
                      _toggleValue(
                        value: value,
                        selectedValues: _bodyParts,
                        onChanged: (next) {
                          setState(() {
                            _bodyParts = next;
                          });
                        },
                      );
                    },
                  ),
                ],

                if (widget.options.inventory.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  ExerciseFilterChipSection(
                    title: 'Инвентарь',
                    values: widget.options.inventory,
                    selectedValues: _inventory,
                    onToggle: (value) {
                      _toggleValue(
                        value: value,
                        selectedValues: _inventory,
                        onChanged: (next) {
                          setState(() {
                            _inventory = next;
                          });
                        },
                      );
                    },
                  ),
                ],

                if (widget.options.exerciseTypes.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  ExerciseFilterChipSection(
                    title: 'Тип упражнения',
                    values: widget.options.exerciseTypes,
                    selectedValues: _exerciseTypes,
                    onToggle: (value) {
                      _toggleValue(
                        value: value,
                        selectedValues: _exerciseTypes,
                        onChanged: (next) {
                          setState(() {
                            _exerciseTypes = next;
                          });
                        },
                      );
                    },
                  ),
                ],

                const SizedBox(height: 24),

                PrimaryButton(
                  text: 'Применить',
                  onPressed: _apply,
                  height: 38,
                  textStyle: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _trackingTypeLabel(String value) {
    return exerciseTypeLabel(exerciseTypeFromApi(value));
  }
}