import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:med_reability/utils/assets/app_assets.dart';
import 'package:med_reability/utils/theme/app_theme.dart';
import 'package:med_reability/utils/widgets/app_circle_icon_button.dart';

class AppTopActionsBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onNotify;

  const AppTopActionsBar({
    super.key,
    required this.onBack,
    required this.onNotify,
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
        const Spacer(),
        AppCircleIconButton(
          onTap: onNotify,
          icon: SvgPicture.asset(
            AppAssets.notificationsIcon,
            width: 18,
            height: 18,
            colorFilter: ColorFilter.mode(
              colors.textPrimary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }
}