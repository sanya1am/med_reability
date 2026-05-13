// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:med_reability/features/patient/presentation/page/patient_home_page.dart';
// import 'package:med_reability/features/patient/presentation/page/patient_trainings_page.dart';
// import 'package:med_reability/utils/assets/app_assets.dart';
// import 'package:med_reability/utils/widgets/app_bottom_nav.dart';
// import 'package:med_reability/utils/widgets/app_header.dart';
//
// class PatientMainPage extends StatefulWidget {
//   const PatientMainPage({super.key});
//
//   @override
//   State<PatientMainPage> createState() => _PatientMainPageState();
// }
//
// class _PatientMainPageState extends State<PatientMainPage> {
//   int _index = 1;
//
//   void _onNav(int i) {
//     if (_index == i) return;
//     setState(() => _index = i);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final title = switch (_index) {
//       0 => 'Тренировки',
//       _ => 'Главная',
//     };
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               AppHeader(
//                 title: title,
//                 actionIconWidget: SvgPicture.asset(
//                   AppAssets.notificationsIcon,
//                 ),
//                 onAction: () {},
//               ),
//               Expanded(
//                 child: IndexedStack(
//                   index: _index,
//                   children: const [
//                     PatientTrainingsPage(),
//                     PatientHomePage(),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 24,
//             child: SafeArea(
//               top: false,
//               child: Center(
//                 child: AppBottomNav(
//                   index: _index,
//                   onTap: _onNav,
//                   items: [
//                     BottomNavItem(
//                       icon: SvgPicture.asset(AppAssets.heartIcon),
//                     ),
//                     BottomNavItem(
//                       icon: SvgPicture.asset(AppAssets.homeIcon),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }