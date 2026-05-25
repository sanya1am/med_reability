import 'package:go_router/go_router.dart';
import 'package:med_reability/features/patient/presentation/page/patient_home_page.dart';
import 'package:med_reability/features/patient/presentation/page/patient_notifications_page.dart';
import 'package:med_reability/features/patient/presentation/page/patient_shell_page.dart';
import 'package:med_reability/features/patient/presentation/page/patient_trainings_page.dart';
import '../../features/profile/presentation/page/edit_profile_page.dart';
import 'app_route_names.dart';

final patientShellRoute = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return PatientShellPage(
      navigationShell: navigationShell,
      location: state.uri.toString(),
    );
  },
  branches: [
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/patient/trainings',
          name: AppRouteNames.patientTrainings,
          builder: (context, state) => const PatientTrainingsPage(),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/patient/home',
          name: AppRouteNames.patientHome,
          builder: (context, state) => const PatientHomePage(),
          routes: [
            GoRoute(
              path: 'edit-profile',
              name: AppRouteNames.patientEditProfile,
              builder: (context, state) => const EditProfilePage(),
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/patient/notifications',
          name: AppRouteNames.patientNotifications,
          builder: (context, state) => const PatientNotificationsPage(),
        ),
      ],
    ),
  ],
);