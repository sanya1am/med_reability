import 'package:go_router/go_router.dart';
import 'package:med_reability/features/doctor/presentation/page/doctor_home_page.dart';
import 'package:med_reability/features/doctor/presentation/page/doctor_patients_page.dart';
import 'package:med_reability/features/doctor/presentation/page/doctor_web_notifications_page.dart';
import 'package:med_reability/features/doctor/presentation/page/doctor_shell_page.dart';
import 'package:med_reability/features/exercises/presentation/page/exercise_details_page.dart';
import 'package:med_reability/features/exercises/presentation/page/exercises_page.dart';
import '../../features/doctor/presentation/page/doctor_patient_overview_page.dart';
import '../../features/profile/presentation/page/edit_profile_page.dart';
import 'app_route_names.dart';

final doctorShellRoute = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return DoctorShellPage(
      navigationShell: navigationShell,
      location: state.uri.toString(),
    );
  },
  branches: [
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/doctor/patients',
          name: AppRouteNames.doctorPatients,
          builder: (context, state) => const DoctorPatientsPage(),
          routes: [
            GoRoute(
              path: ':patientId',
              name: AppRouteNames.doctorPatientOverview,
              builder: (context, state) {
                final patientId = state.pathParameters['patientId']!;

                return DoctorPatientOverviewPage(
                  patientId: patientId,
                );
              },
            ),
          ],
        ),
      ],
    ),

    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/doctor/exercises',
          name: AppRouteNames.doctorExercises,
          builder: (context, state) => const ExercisesPage(),
          routes: [
            GoRoute(
              path: ':exerciseId',
              name: AppRouteNames.doctorExerciseDetails,
              builder: (context, state) {
                final exerciseId = state.pathParameters['exerciseId']!;

                return ExerciseDetailsPage(
                  exerciseId: exerciseId,
                );
              },
            ),
          ],
        ),
      ],
    ),

    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/doctor/home',
          name: AppRouteNames.doctorHome,
          builder: (context, state) => const DoctorHomePage(),
          routes: [
            GoRoute(
              path: 'edit-profile',
              name: AppRouteNames.doctorEditProfile,
              builder: (context, state) => const EditProfilePage(),
            ),
          ],
        ),
      ],
    ),

    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/doctor/notifications',
          name: AppRouteNames.doctorNotifications,
          builder: (context, state) => const DoctorWebNotificationsPage(),
        ),
      ],
    ),
  ],
);