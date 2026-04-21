import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:med_reability/utils/assets/app_assets.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

class ExerciseCreateMediaUploadBox extends StatelessWidget {
  final VoidCallback onTap;
  final List<String> existingMediaUrls;
  final List<String> pickedFileNames;
  final void Function(int index)? onRemovePicked;

  const ExerciseCreateMediaUploadBox({
    super.key,
    required this.onTap,
    this.existingMediaUrls = const [],
    this.pickedFileNames = const [],
    this.onRemovePicked,
  });

  @override
  Widget build(BuildContext context) {
    final hasAnyMedia =
        existingMediaUrls.isNotEmpty || pickedFileNames.isNotEmpty;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: hasAnyMedia
          ? _FilledMediaState(
        existingMediaUrls: existingMediaUrls,
        pickedFileNames: pickedFileNames,
        onRemovePicked: onRemovePicked,
      )
          : const _EmptyMediaState(),
    );
  }
}

class _EmptyMediaState extends StatelessWidget {
  const _EmptyMediaState();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return DottedBorder(
      color: colors.border,
      strokeWidth: 1.2,
      dashPattern: const [6, 5],
      borderType: BorderType.RRect,
      radius: const Radius.circular(18),
      child: Container(
        width: double.infinity,
        height: 220,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppAssets.uploadMediaIcon,
              width: 44,
              height: 44,
            ),
            const SizedBox(height: 14),
            Text(
              'Загрузить изображение или видео',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilledMediaState extends StatelessWidget {
  final List<String> existingMediaUrls;
  final List<String> pickedFileNames;
  final void Function(int index)? onRemovePicked;

  const _FilledMediaState({
    required this.existingMediaUrls,
    required this.pickedFileNames,
    required this.onRemovePicked,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colors.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Медиафайлы',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          if (existingMediaUrls.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Текущие:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            ...existingMediaUrls.map(
                  (url) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.link,
                      size: 18,
                      color: colors.textPrimary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        url,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (pickedFileNames.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Будут загружены:',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            ...List.generate(pickedFileNames.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.insert_drive_file_outlined,
                      size: 18,
                      color: colors.textPrimary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        pickedFileNames[index],
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    if (onRemovePicked != null)
                      GestureDetector(
                        onTap: () => onRemovePicked!(index),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: colors.textSecondary,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ],
          const SizedBox(height: 8),
          Text(
            'Нажмите, чтобы выбрать файлы',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}