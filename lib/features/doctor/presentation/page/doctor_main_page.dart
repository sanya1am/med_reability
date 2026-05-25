import 'package:flutter/material.dart';
import 'doctor_mobile_main_page.dart';

class DoctorMainPage extends StatelessWidget {
  const DoctorMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWebLayout = constraints.maxWidth >= 900;

        if (isWebLayout) {
          // return ;
        }

        return const DoctorMobileMainPage();
      },
    );
  }
}