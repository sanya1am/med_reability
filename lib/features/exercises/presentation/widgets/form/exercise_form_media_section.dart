import 'package:flutter/material.dart';
import 'package:med_reability/features/exercises/presentation/state/exercise_form_state.dart';
import 'package:med_reability/features/exercises/presentation/widgets/exercise_create_media_upload_box.dart';
import 'package:med_reability/features/exercises/presentation/widgets/form/exercise_media_replacement_warning.dart';

class ExerciseFormMediaSection extends StatelessWidget {
  final ExerciseFormState formState;
  final VoidCallback onPickMedia;
  final ValueChanged<int> onRemovePickedMediaAt;

  const ExerciseFormMediaSection({
    super.key,
    required this.formState,
    required this.onPickMedia,
    required this.onRemovePickedMediaAt,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (formState.isEdit && formState.existingMediaUrls.isNotEmpty) ...[
          const ExerciseMediaReplacementWarning(),
          const SizedBox(height: 12),
        ],
        ExerciseCreateMediaUploadBox(
          onTap: onPickMedia,
          existingMediaUrls: formState.existingMediaUrls,
          pickedFileNames: formState.pickedMediaFiles
              .map((file) => file.name)
              .toList(growable: false),
          onRemovePicked: onRemovePickedMediaAt,
        ),
      ],
    );
  }
}