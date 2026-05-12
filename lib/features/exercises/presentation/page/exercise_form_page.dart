import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/core/di/providers.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise_filter_options.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise_media_file.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise_type.dart';
import 'package:med_reability/features/exercises/presentation/state/exercise_form_state.dart';
import 'package:med_reability/features/exercises/presentation/view_model/exercise_form_view_model.dart';
import 'package:med_reability/features/exercises/presentation/widgets/exercise_create_media_upload_box.dart';
import 'package:med_reability/features/exercises/presentation/widgets/exercise_create_step_input.dart';
import 'package:med_reability/features/exercises/presentation/widgets/filters/exercise_filter_chip_section.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_secondary_button.dart';
import 'package:med_reability/utils/widgets/app_text_field.dart';
import 'package:med_reability/utils/widgets/app_top_actions_bar.dart';
import 'package:med_reability/utils/widgets/primary_button.dart';


final _exerciseFormFilterOptionsProvider =
FutureProvider.autoDispose<ExerciseFilterOptions>((ref) {
  return ref.read(getExerciseFilterOptionsUseCaseProvider).call();
});

class ExerciseFormPage extends ConsumerStatefulWidget {
  final Exercise? initialExercise;

  const ExerciseFormPage({
    super.key,
    this.initialExercise,
  });

  @override
  ConsumerState<ExerciseFormPage> createState() => _ExerciseFormPageState();
}

class _ExerciseFormPageState extends ConsumerState<ExerciseFormPage> {
  late final TextEditingController nameCtrl;
  late final TextEditingController descCtrl;
  late List<TextEditingController> steps;

  ExerciseFormViewModel get _vm =>
      ref.read(exerciseFormViewModelProvider(widget.initialExercise).notifier);

  @override
  void initState() {
    super.initState();

    final exercise = widget.initialExercise;

    nameCtrl = TextEditingController(text: exercise?.name ?? '');
    descCtrl = TextEditingController(text: exercise?.description ?? '');

    final initialSteps = exercise?.steps ?? const <String>[];
    steps = initialSteps.isNotEmpty
        ? initialSteps.map((s) => TextEditingController(text: s)).toList()
        : [TextEditingController()];
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    descCtrl.dispose();

    for (final controller in steps) {
      controller.dispose();
    }

    super.dispose();
  }

  Future<void> _pickMedia() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'mp4', 'mov', 'avi'],
    );

    if (result == null || result.files.isEmpty) return;

    final files = result.files
        .where((file) => file.bytes != null)
        .map(
          (file) => ExerciseMediaFile(
        name: file.name,
        bytes: file.bytes!,
      ),
    )
        .toList();

    if (files.isEmpty) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось прочитать выбранные файлы'),
        ),
      );

      return;
    }

    _vm.setPickedMediaFiles(files);
  }

  void _removePickedMediaAt(int index) {
    _vm.removePickedMediaAt(index);
  }

  void _addStep() {
    setState(() {
      steps.add(TextEditingController());
    });
  }

  void _removeStep(int index) {
    if (steps.length == 1) return;

    setState(() {
      steps[index].dispose();
      steps.removeAt(index);
    });
  }

  Future<void> _submit(ExerciseFormState formState) async {
    final stepsList = steps.map((controller) => controller.text).toList();

    if (formState.requiresMediaReplacementConfirmation) {
      final shouldContinue = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Заменить медиа'),
            content: const Text(
              'У упражнения уже есть медиафайлы. '
                  'Если сохранить без выбора новых файлов, текущие медиа будут удалены.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Сохранить'),
              ),
            ],
          );
        },
      );

      if (shouldContinue != true) return;
    }

    final result = await _vm.submit(
      name: nameCtrl.text,
      description: descCtrl.text,
      steps: stepsList,
    );

    if (!mounted) return;

    if (result.isSuccess) {
      Navigator.pop(context, true);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.errorMessage ?? 'Не удалось сохранить упражнение'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final formState = ref.watch(
      exerciseFormViewModelProvider(widget.initialExercise),
    );

    final filterOptionsAsync = ref.watch(_exerciseFormFilterOptionsProvider);

    final submitText = formState.isEdit ? 'Сохранить' : 'Создать';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 12, 28, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTopActionsBar(
                    onBack: () => Navigator.pop(context),
                    onNotify: () {},
                  ),

                  const SizedBox(height: 16),

                  if (formState.isEdit &&
                      formState.existingMediaUrls.isNotEmpty) ...[
                    _MediaReplacementWarning(),
                    const SizedBox(height: 12),
                  ],

                  ExerciseCreateMediaUploadBox(
                    onTap: _pickMedia,
                    existingMediaUrls: formState.existingMediaUrls,
                    pickedFileNames: formState.pickedMediaFiles
                        .map((file) => file.name)
                        .toList(growable: false),
                    onRemovePicked: _removePickedMediaAt,
                  ),

                  const SizedBox(height: 18),

                  _SectionTitle(text: 'Тип'),
                  const SizedBox(height: 8),
                  _ExerciseTrackingTypeSelector(
                    value: formState.type,
                    onChanged: _vm.setType,
                  ),

                  const SizedBox(height: 14),

                  _SectionTitle(text: 'Название'),
                  const SizedBox(height: 8),
                  AppTextField(
                    hintText: 'Введите название упражнения',
                    controller: nameCtrl,
                  ),

                  const SizedBox(height: 14),

                  _SectionTitle(text: 'Описание'),
                  const SizedBox(height: 8),
                  AppTextField(
                    hintText: 'Введите описание упражнения',
                    controller: descCtrl,
                    maxLines: 4,
                  ),

                  const SizedBox(height: 14),

                  if (!formState.isEdit) ...[
                    _PrivateAccessSwitch(
                      isPrivate: !formState.isGlobal,
                      onChanged: (value) {
                        _vm.setIsGlobal(!value);
                      },
                    ),
                    const SizedBox(height: 16),
                  ],

                  filterOptionsAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                    error: (_, __) => const _FilterOptionsLoadError(),
                    data: (options) {
                      return _ExerciseFilterOptionsFields(
                        options: options,
                        formState: formState,
                        vm: _vm,
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  _SectionTitle(text: 'Инструкция'),
                  const SizedBox(height: 10),

                  ...List.generate(steps.length, (index) {
                    return ExerciseCreateStepInput(
                      index: index,
                      controller: steps[index],
                      canRemove: steps.length > 1,
                      onRemove: () => _removeStep(index),
                    );
                  }),

                  const SizedBox(height: 8),

                  SecondaryButton(
                    text: 'Добавить шаг',
                    onPressed: formState.isSubmitting ? null : _addStep,
                    height: 38,
                    textStyle: textTheme.titleSmall,
                  ),

                  const SizedBox(height: 16),

                  PrimaryButton(
                    text: submitText,
                    onPressed: formState.isSubmitting
                        ? null
                        : () => _submit(formState),
                    loading: formState.isSubmitting,
                    height: 38,
                    textStyle: textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MediaReplacementWarning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colors.border,
        ),
      ),
      child: Text(
        'Текущие медиафайлы будут заменены новыми при сохранении.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: colors.textPrimary,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontSize: 18,
      ),
    );
  }
}

class _ExerciseTrackingTypeSelector extends StatelessWidget {
  final ExerciseType value;
  final ValueChanged<ExerciseType?> onChanged;

  const _ExerciseTrackingTypeSelector({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final brightness = Theme.of(context).brightness;

    final selectedBackground = brightness == Brightness.dark
        ? colors.surface
        : colors.background;

    return Container(
      width: double.infinity,
      height: 38,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: colors.dialogBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TrackingTypeSegment(
              text: 'Время',
              selected: value == ExerciseType.time,
              selectedBackground: selectedBackground,
              onTap: () => onChanged(ExerciseType.time),
            ),
          ),
          Expanded(
            child: _TrackingTypeSegment(
              text: 'Повторения',
              selected: value == ExerciseType.repetition,
              selectedBackground: selectedBackground,
              onTap: () => onChanged(ExerciseType.repetition),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackingTypeSegment extends StatelessWidget {
  final String text;
  final bool selected;
  final Color selectedBackground;
  final VoidCallback onTap;

  const _TrackingTypeSegment({
    required this.text,
    required this.selected,
    required this.selectedBackground,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? selectedBackground : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colors.textPrimary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}


class _PrivateAccessSwitch extends StatelessWidget {
  final bool isPrivate;
  final ValueChanged<bool> onChanged;

  const _PrivateAccessSwitch({
    required this.isPrivate,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Switch(
          value: isPrivate,
          onChanged: onChanged,
        ),

        Expanded(
          child: Text(
            'Приватный доступ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _ExerciseFilterOptionsFields extends StatelessWidget {
  final ExerciseFilterOptions options;
  final ExerciseFormState formState;
  final ExerciseFormViewModel vm;

  const _ExerciseFilterOptionsFields({
    required this.options,
    required this.formState,
    required this.vm,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleSmall?.copyWith(
      fontSize: 18,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (options.bodyParts.isNotEmpty) ...[
          ExerciseFilterChipSection(
            title: 'Часть тела',
            values: options.bodyParts,
            selectedValues: formState.bodyParts,
            onToggle: vm.toggleBodyPart,
            textStyle: titleStyle,
          ),
          const SizedBox(height: 16),
        ],

        if (options.inventory.isNotEmpty) ...[
          ExerciseFilterChipSection(
            title: 'Инвентарь',
            values: options.inventory,
            selectedValues: formState.inventory,
            onToggle: vm.toggleInventory,
            textStyle: titleStyle,
          ),
          const SizedBox(height: 16),
        ],

        if (options.exerciseTypes.isNotEmpty) ...[
          ExerciseFilterChipSection(
            title: 'Тип упражнения',
            values: options.exerciseTypes,
            selectedValues: formState.exerciseTypes,
            onToggle: vm.toggleExerciseType,
            textStyle: titleStyle,
          ),
        ],
      ],
    );
  }
}

class _FilterOptionsLoadError extends StatelessWidget {
  const _FilterOptionsLoadError();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colors.border,
        ),
      ),
      child: Text(
        'Не удалось загрузить дополнительные фильтры упражнения. '
            'Можно сохранить упражнение без них.',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: colors.textSecondary,
        ),
      ),
    );
  }
}