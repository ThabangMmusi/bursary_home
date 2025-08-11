import 'package:bursary_home_ui/theme/styles.dart';
import 'package:bursary_home_ui/widgets/logo_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:bursary_home_ui/widgets/sidebar_navigation_item.dart';
import 'package:student_app/features/auth/bloc/app_bloc.dart';

class SideMenu extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const SideMenu({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LogoComponent(),
          VSpace.xxl,
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                SidebarNavigationItem(
                  title: 'Dashboard',
                  icon: Icons.dashboard,
                  isActive: navigationShell.currentIndex == 0,
                  onPressed: () => navigationShell.goBranch(0),
                ),
                SidebarNavigationItem(
                  title: 'Bursaries',
                  icon: Icons.school,
                  isActive: navigationShell.currentIndex == 1,
                  onPressed: () => navigationShell.goBranch(1),
                ),
                SidebarNavigationItem(
                  title: 'Applications',
                  icon: Icons.description,
                  isActive: navigationShell.currentIndex == 2,
                  onPressed: () => navigationShell.goBranch(2),
                ),
                SidebarNavigationItem(
                  title: 'Profile',
                  icon: Icons.person,
                  isActive: navigationShell.currentIndex == 3,
                  onPressed: () => navigationShell.goBranch(3),
                ),
                SidebarNavigationItem(
                  title: 'Logout',
                  icon: Icons.logout,
                  onPressed: () {
                    context.read<AppBloc>().add(AppLogoutRequested());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
