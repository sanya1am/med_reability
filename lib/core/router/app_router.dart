import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:med_reability/features/auth/presentation/view_model/auth_view_model.dart';

import '../../features/auth/domain/entities/role.dart';
import '../../features/auth/presentation/page/login_page.dart';
import '../../features/admin/presentation/page/admin_home_page.dart';
import '../../features/doctor/presentation/page/doctor_home_page.dart';
import '../../features/patient/presentation/page/patient_home_page.dart';
import 'router_refresh.dart';

GoRouter buildRouter(Ref ref) {
  final refresh = RouterRefreshNotifier(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authViewModelProvider);
      final loc = state.matchedLocation;
      final isLogin = loc == '/login';

      if (!auth.isAuthed) {
        return isLogin ? null : '/login';
      }

      final role = auth.session!.role;
      if (isLogin) {
        return switch (role) {
          UserRole.admin => '/admin',
          UserRole.doctor => '/doctor',
          UserRole.patient => '/patient',
        };
      }

      if (loc.startsWith('/admin') && role != UserRole.admin) return '/login';
      if (loc.startsWith('/doctor') && role != UserRole.doctor) return '/login';
      if (loc.startsWith('/patient') && role != UserRole.patient) return '/login';

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/admin', builder: (_, __) => const AdminHomePage()),
      GoRoute(path: '/doctor', builder: (_, __) => const DoctorHomePage()),
      GoRoute(path: '/patient', builder: (_, __) => const PatientHomePage()),
    ],
  );
}