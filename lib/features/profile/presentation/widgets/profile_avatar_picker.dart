import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

class ProfileAvatarPicker extends StatelessWidget {
  final String? imageUrl;
  final Uint8List? imageBytes;
  final VoidCallback onTap;

  const ProfileAvatarPicker({
    super.key,
    required this.imageUrl,
    required this.imageBytes,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: _buildAvatar(colors),
          ),
          Positioned(
            right: -2,
            bottom: -2,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: colors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.background,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.photo_camera_outlined,
                  size: 18,
                  color: colors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(AppColors colors) {
    if (imageBytes != null) {
      return ClipOval(
        child: Image.memory(
          imageBytes!,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
        ),
      );
    }

    final url = imageUrl?.trim();
    if (url != null && url.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          url,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return _placeholder(colors);
          },
        ),
      );
    }

    return _placeholder(colors);
  }

  Widget _placeholder(AppColors colors) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person,
        size: 44,
        color: colors.textPrimary,
      ),
    );
  }
}