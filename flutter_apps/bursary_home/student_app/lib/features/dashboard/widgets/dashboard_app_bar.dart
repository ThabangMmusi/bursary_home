import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bursary_home_ui/widgets/top_header_bar.dart';
import 'package:student_app/features/auth/bloc/app_bloc.dart';
import 'package:student_app/features/auth/bloc/app_state.dart';

class DashboardAppBar extends StatelessWidget {
  const DashboardAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, appState) {
        late String userName;
        String userRole = appState.isStudent ? 'Student' : 'Bursary Provider';
        String userProfileImagePath =
            'assets/images/boy white.png'; // Placeholder

        if (appState.status == AppStatus.authenticated) {
          userName =
              '${appState.user.name ?? ''} ${appState.user.surname ?? ''}'
                  .trim();
        }
        if (userName.isEmpty) {
          userName = 'User';
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
