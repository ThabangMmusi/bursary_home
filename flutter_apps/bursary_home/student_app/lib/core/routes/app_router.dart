import 'package:student_app/features/dashboard/views/bursaries_page.dart';
import 'package:student_app/features/shell/views/app_shell.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:data_layer/data_layer.dart';
import 'package:student_app/features/auth/bloc/auth_bloc.dart';
import 'package:student_app/features/auth/bloc/auth_state.dart';
import 'package:student_app/features/auth/views/login_page.dart';
import 'package:student_app/features/profile/presentation/pages/complete_profile_page.dart';
import 'package:student_app/features/profile/views/profile_page.dart';
import 'package:student_app/features/profile/bloc/profile_bloc.dart';
import 'package:student_app/features/dashboard/views/dashboard_page.dart';
import 'package:student_app/features/applications/bloc/applications_bloc.dart';
import 'package:student_app/features/applications/views/applications_page.dart';
import 'package:student_app/features/dashboard/bloc/bursary_bloc.dart';

class AppRouter {
  final AuthBloc authBloc;
  final ProfileBloc profileBloc;
  final ApplicationsBloc applicationsBloc;

  AppRouter({
    required this.authBloc,
    required this.profileBloc,
    required this.applicationsBloc,
  });

  late final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          // This will be the initial page, which will redirect based on auth status
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: '/complete-profile',
        builder: (BuildContext context, GoRouterState state) {
          return const CompleteProfilePage();
        },
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/dashboard',
                pageBuilder:
                    (context, state) => NoTransitionPage(
                      child: BlocProvider<BursaryBloc>(
                        create:
                            (context) => BursaryBloc(
                              bursaryRepository:
                                  context.read<BursaryRepository>(),
                              authBloc: authBloc,
                            ),
                        child: const DashboardPage(),
                      ),
                    ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/bursaries',
                pageBuilder:
                    (context, state) => NoTransitionPage(
                      child: BlocProvider<BursaryBloc>(
                        create:
                            (context) => BursaryBloc(
                              bursaryRepository:
                                  context.read<BursaryRepository>(),
                              authBloc: authBloc,
                            ),
                        child: const BursariesPage(),
                      ),
                    ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/applications',
                pageBuilder:
                    (context, state) =>
                        const NoTransitionPage(child: ApplicationsPage()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/profile',
                pageBuilder:
                    (context, state) =>
                        const NoTransitionPage(child: ProfilePage()),
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = authBloc.state.status == AuthStatus.authenticated;
      final bool profileComplete = authBloc.state.user.hasCompletedProfile;

      final bool loggingIn = state.matchedLocation == '/login';
      final bool completingProfile =
          state.matchedLocation == '/complete-profile';

      // If not logged in, and not on the login page, redirect to login
      if (!loggedIn && !loggingIn) {
        return '/login';
      }

      // If logged in:
      if (loggedIn) {
        // If profile is not complete and not already on complete-profile page, redirect to complete-profile
        if (authBloc.state.user.isNotEmpty &&
            !profileComplete &&
            !completingProfile) {
          return '/complete-profile'; // Redirect to a common path for profile completion
        }
        // If profile is complete and on login or complete-profile page, redirect to dashboard (or home)
        if (profileComplete && (loggingIn || completingProfile)) {
          return '/dashboard';
        }
      }

      // No redirect
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
