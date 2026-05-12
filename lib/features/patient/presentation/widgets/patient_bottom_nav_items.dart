import 'package:flutter_svg/flutter_svg.dart';
import 'package:med_reability/utils/assets/app_assets.dart';
import 'package:med_reability/utils/widgets/app_bottom_nav.dart';

final patientBottomNavItems = [
  BottomNavItem(
    icon: SvgPicture.asset(AppAssets.heartIcon),
  ),
  BottomNavItem(
    icon: SvgPicture.asset(AppAssets.homeIcon),
  ),
];