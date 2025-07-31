import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bursary_home_ui/widgets/top_header_bar.dart';
import 'package:student_app/features/auth/bloc/auth_bloc.dart';
import 'package:student_app/features/auth/bloc/auth_state.dart';

class DashboardAppBar extends StatelessWidget {
  const DashboardAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        String userName = 'User';
        String userRole = 'Student'; // Always student for this app
        String userProfileImagePath =
            'assets/images/boy white.png'; // Placeholder

        if (authState.status == AuthStatus.authenticated) {
          userName =
              '${authState.user.name ?? ''} ${authState.user.surname ?? ''}'
                  .trim();
          if (userName.isEmpty) {
            userName = 'User';
          }
        }

        return Container(
          margin: const EdgeInsets.only(top: 16.0),
          padding: const EdgeInsets.all(16.0),
          child: TopHeaderBar(
            userName: userName,
            userRole: userRole,
            userProfileImagePath: userProfileImagePath,
            onSearchChanged: (query) {
              // TODO: Implement search logic
              print('Search query: $query');
            },
            onNotificationPressed: () {
              // TODO: Implement notification logic
              print('Notification icon pressed');
            },
          ),
        );
      },
    );
  }
}
