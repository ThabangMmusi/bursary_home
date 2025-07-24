import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:student_app/features/auth/bloc/auth_bloc.dart';
import 'package:student_app/features/auth/bloc/auth_state.dart';
import 'package:student_app/features/auth/views/login_page.dart';
import 'package:student_app/features/profile/views/complete_profile_page.dart';
import 'package:student_app/features/profile/views/profile_page.dart';
import 'package:student_app/features/profile/bloc/profile_bloc.dart';
import 'package:student_app/features/dashboard/views/dashboard_page.dart';
import 'package:student_app/features/dashboard/views/bursary_details_page.dart';
import 'package:student_app/data/models/bursary_model.dart';
import 'package:student_app/features/applications/bloc/applications_bloc.dart';
import 'package:student_app/features/applications/views/applications_page.dart';

class AppRouter {
  final AuthBloc authBloc;
  final ProfileBloc profileBloc;
  final ApplicationsBloc applicationsBloc;

  AppRouter({required this.authBloc, required this.profileBloc, required this.applicationsBloc});

  late final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          // This will be the initial page, which will redirect based on auth status
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
      GoRoute(
        path: '/profile',
        builder: (BuildContext context, GoRouterState state) {
          return const ProfilePage();
        },
      ),
      GoRoute(
        path: '/dashboard',
        builder: (BuildContext context, GoRouterState state) {
          return const DashboardPage();
        },
      ),
      GoRoute(
        path: '/bursary-details/:id',
        builder: (BuildContext context, GoRouterState state) {
          final bursary = state.extra as Bursary?; // Cast extra to Bursary
          if (bursary == null) {
            return const Text('Error: Bursary not found'); // Handle error or redirect
          }
          return BursaryDetailsPage(bursary: bursary);
        },
      ),
      GoRoute(
        path: '/applications',
        builder: (BuildContext context, GoRouterState state) {
          return const ApplicationsPage();
        },
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = authBloc.state.status == AuthStatus.authenticated;
      final bool profileComplete = profileBloc.state.profile?.status == 'complete'; // Assuming 'complete' status

      final bool loggingIn = state.matchedLocation == '/login';
      final bool completingProfile = state.matchedLocation == '/complete-profile';

      // If not logged in, and not on the login page, redirect to login
      if (!loggedIn && !loggingIn) {
        return '/login';
      }

      // If logged in:
      if (loggedIn) {
        // If profile is not complete and not already on complete-profile page, redirect to complete-profile
        if (!profileComplete && !completingProfile) {
          return '/complete-profile';
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
