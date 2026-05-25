import 'package:go_router/go_router.dart';
import 'package:med_reability/features/admin/presentation/page/admin_doctors_page.dart';
import 'package:med_reability/features/admin/presentation/page/admin_home_page.dart';
import 'package:med_reability/features/admin/presentation/page/admin_shell_page.dart';
import '../../features/admin/presentation/page/admin_patients_page.dart';
import '../../features/admin/presentation/page/user_form_page.dart';
import '../../features/profile/presentation/page/edit_profile_page.dart';
import 'app_route_names.dart';

final adminShellRoute = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return AdminShellPage(
      navigationShell: navigationShell,
      location: state.uri.toString(),
    );
  },
  branches: [
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/admin/doctors',
          name: AppRouteNames.adminDoctors,
          builder: (context, state) => const AdminDoctorsPage(),
          routes: [
            GoRoute(
              path: 'create',
              name: AppRouteNames.adminDoctorsUserForm,
              builder: (context, state) => const UserFormPage(),
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/admin/patients',
          name: AppRouteNames.adminPatients,
          builder: (context, state) => const AdminPatientsPage(),
          routes: [
            GoRoute(
              path: 'create',
              name: AppRouteNames.adminPatientsUserForm,
              builder: (context, state) => const UserFormPage(),
            ),
          ],
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          path: '/admin/home',
          name: AppRouteNames.adminHome,
          builder: (context, state) => const AdminHomePage(),
          routes: [
            GoRoute(
              path: 'edit-profile',
              name: AppRouteNames.adminEditProfile,
              builder: (context, state) => const EditProfilePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);