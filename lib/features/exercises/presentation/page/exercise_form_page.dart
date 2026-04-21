import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/features/exercises/presentation/state/exercise_form_state.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

import '../../../../utils/widgets/app_text_field.dart';
import '../../../../utils/widgets/primary_button.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/exercise_media_file.dart';
import '../view_model/exercise_form_view_model.dart';
import '../widgets/exercise_create_media_upload_box.dart';
import '../widgets/exercise_create_step_input.dart';
import '../widgets/exercise_create_top_actions.dart';
import '../widgets/exercise_type_dropdown.dart';

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

    final e = widget.initialExercise;

    nameCtrl = TextEditingController(text: e?.name ?? '');
    descCtrl = TextEditingController(text: e?.description ?? '');

    final initialSteps = e?.steps ?? const <String>[];
    steps = initialSteps.isNotEmpty
        ? initialSteps.map((s) => TextEditingController(text: s)).toList()
        : [TextEditingController()];
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    descCtrl.dispose();
    for (final c in steps) {
      c.dispose();
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
        .where((f) => f.bytes != null)
        .map(
          (f) => ExerciseMediaFile(
        name: f.name,
        bytes: f.bytes!,
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
    final stepsList = steps.map((c) => c.text).toList(growable: false);

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
    final colors = context.appColors;
    final formState = ref.watch(
      exerciseFormViewModelProvider(widget.initialExercise),
    );

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
                  ExerciseCreateTopActions(
                    onBack: () => Navigator.pop(context),
                    onNotify: () {},
                  ),
                  const SizedBox(height: 16),

                  if (formState.isEdit && formState.existingMediaUrls.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: colors.border),
                      ),
                      child: Text(
                        'Текущие медиафайлы будут заменены новыми при сохранении.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.textPrimary,
                        ),
                      ),
                    ),
                  ],

                  ExerciseCreateMediaUploadBox(
                    onTap: _pickMedia,
                    existingMediaUrls: formState.existingMediaUrls,
                    pickedFileNames: formState.pickedMediaFiles
                        .map((e) => e.name)
                        .toList(growable: false),
                    onRemovePicked: _removePickedMediaAt,
                  ),
                  const SizedBox(height: 18),

                  Text('Название', style: textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  AppTextField(
                    hintText: 'Введите название упражнения',
                    controller: nameCtrl,
                  ),
                  const SizedBox(height: 14),

                  Text('Описание', style: textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  AppTextField(
                    hintText: 'Введите описание упражнения',
                    controller: descCtrl,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 14),

                  Text('Тип упражнения', style: textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  ExerciseTypeDropdown(
                    value: formState.type,
                    onChanged: _vm.setType,
                  ),
                  const SizedBox(height: 16),

                  if (!formState.isEdit) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            'Сделать доступным всем инструкторам клиники',
                            style: textTheme.bodyMedium,
                          ),
                        ),
                        Switch(
                          value: formState.isGlobal,
                          onChanged: _vm.setIsGlobal,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  Text('Инструкция', style: textTheme.bodyMedium),
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
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: 'Добавить шаг',
                      onPressed: formState.isSubmitting ? null : _addStep,
                      height: 38,
                      textStyle: textTheme.titleSmall,
                    ),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: submitText,
                      onPressed: formState.isSubmitting
                          ? null
                          : () => _submit(formState),
                      loading: formState.isSubmitting,
                      height: 38,
                      textStyle: textTheme.titleSmall,
                    ),
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