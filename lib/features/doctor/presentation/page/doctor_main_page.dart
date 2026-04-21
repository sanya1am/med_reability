import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:med_reability/features/exercises/presentation/page/exercises_page.dart';
import 'package:med_reability/utils/assets/app_assets.dart';
import '../../../../utils/widgets/app_bottom_nav.dart';
import '../../../../utils/widgets/app_header.dart';
import 'doctor_home_page.dart';
import 'doctor_patients_page.dart';

class DoctorMainPage extends ConsumerStatefulWidget {
  const DoctorMainPage({super.key});

  @override
  ConsumerState<DoctorMainPage> createState() => _DoctorMainPageState();
}

class _DoctorMainPageState extends ConsumerState<DoctorMainPage> {
  int _index = 2;

  void _onNav(int i) {
    if (_index == i) return;
    setState(() => _index = i);
  }

  @override
  Widget build(BuildContext context) {
    final title = switch (_index) {
      0 => 'Пациенты',
      1 => 'Упражнения',
      _ => 'Главная',
    };

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              AppHeader(
              title: title,
                actionIconWidget: SvgPicture.asset(AppAssets.notificationsIcon),
                onAction: () {},
              ),
              Expanded(
                child: IndexedStack(
                  index: _index,
                  children: const [
                    DoctorPatientsPage(),
                    ExercisesPage(),
                    DoctorHomePage(),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: SafeArea(
              top: false,
              child: Center(
                child: AppBottomNav(
                  index: _index,
                  onTap: _onNav,
                  items: [
                    BottomNavItem(icon: SvgPicture.asset(AppAssets.listIcon)),
                    BottomNavItem(icon: SvgPicture.asset(AppAssets.heartIcon)),
                    BottomNavItem(icon: SvgPicture.asset(AppAssets.homeIcon)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}