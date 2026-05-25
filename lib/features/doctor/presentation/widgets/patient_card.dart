import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:med_reability/utils/theme/app_theme.dart';

import '../../../../utils/assets/app_assets.dart';

class PatientCard extends StatelessWidget {
  final String name;
  final String subtitle;
  final String? imageUrl;
  final bool hasPlan;
  final VoidCallback? onTap;

  const PatientCard({
    super.key,
    required this.name,
    required this.subtitle,
    required this.hasPlan,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.18)
                  : const Color(0x11000000),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            _PatientAvatar(
              imageUrl: imageUrl,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            if (!hasPlan) ...[
              const SizedBox(width: 12),
              SvgPicture.asset(
                AppAssets.lampIcon,
                width: 24,
                height: 24,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PatientAvatar extends StatelessWidget {
  final String? imageUrl;

  const _PatientAvatar({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final url = imageUrl;

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.surfaceAlt,
      ),
      clipBehavior: Clip.antiAlias,
      child: url == null || url.isEmpty
          ? Icon(
        Icons.person,
        color: colors.textPrimary,
      )
          : Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Icon(
            Icons.person,
            color: colors.textPrimary,
          );
        },
      ),
    );
  }
}