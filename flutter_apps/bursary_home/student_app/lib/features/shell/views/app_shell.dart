import 'package:bursary_home_ui/bursary_home_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_app/features/dashboard/widgets/dashboard_app_bar.dart';
import 'package:student_app/features/dashboard/widgets/side_menu.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideMenu(navigationShell: navigationShell),
          Expanded(
            child: Column(
              children: [
                DashboardAppBar(),
                Expanded(
                  child: navigationShell,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
