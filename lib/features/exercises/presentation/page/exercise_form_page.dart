import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_reability/core/di/providers.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise_filter_options.dart';
import 'package:med_reability/features/exercises/domain/entities/exercise_media_file.dart';
import 'package:med_reability/features/exercises/presentation/state/exercise_form_state.dart';
import 'package:med_reability/features/exercises/presentation/view_model/exercise_form_view_model.dart';
import 'package:med_reability/features/exercises/presentation/widgets/form/exercise_form_desktop_layout.dart';
import 'package:med_reability/features/exercises/presentation/widgets/form/exercise_form_layout_props.dart';
import 'package:med_reability/features/exercises/presentation/widgets/form/exercise_form_mobile_layout.dart';

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
        ? initialSteps.map((step) => TextEditingController(text: step)).toList()
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
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'webp',
        'mp4',
        'mov',
        'avi',
      ],
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
        content: Text(
          result.errorMessage ?? 'Не удалось сохранить упражнение',
        ),
      ),
    );
  }

  void _onBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(
      exerciseFormViewModelProvider(widget.initialExercise),
    );

    final filterOptionsAsync = ref.watch(_exerciseFormFilterOptionsProvider);
    final submitText = formState.isEdit ? 'Сохранить' : 'Создать';

    final props = ExerciseFormLayoutProps(
      formState: formState,
      filterOptionsAsync: filterOptionsAsync,
      nameCtrl: nameCtrl,
      descCtrl: descCtrl,
      steps: steps,
      submitText: submitText,
      onBack: _onBack,
      onPickMedia: _pickMedia,
      onRemovePickedMediaAt: _removePickedMediaAt,
      onTypeChanged: _vm.setType,
      onPrivateAccessChanged: (value) {
        _vm.setIsGlobal(!value);
      },
      onToggleBodyPart: _vm.toggleBodyPart,
      onToggleInventory: _vm.toggleInventory,
      onToggleExerciseType: _vm.toggleExerciseType,
      onAddStep: _addStep,
      onRemoveStep: _removeStep,
      onSubmit: () => _submit(formState),
    );

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;

            if (isDesktop) {
              return ExerciseFormDesktopLayout(
                props: props,
              );
            }

            return ExerciseFormMobileLayout(
              props: props,
            );
          },
        ),
      ),
    );
  }
}