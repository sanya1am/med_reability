import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:med_reability/utils/assets/app_assets.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_circle_icon_button.dart';

class AppTopActionsBar extends StatelessWidget {
  final VoidCallback onBack;

  const AppTopActionsBar({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      children: [
        AppCircleIconButton(
          onTap: onBack,
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 18,
            color: colors.textPrimary,
          ),
        ),
      ],
    );
  }
}