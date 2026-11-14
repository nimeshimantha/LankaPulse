import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/dictionary/presentation/screens/dictionary_screen.dart';
import '../../features/hospitals/presentation/screens/hospitals_screen.dart';
import '../../features/jobs/presentation/screens/jobs_screen.dart';
import '../../features/news/presentation/screens/news_screen.dart';
import '../../features/productivity/presentation/screens/productivity_screen.dart';
import '../../features/utility/presentation/screens/document_locker_screen.dart';
import '../../features/utility/presentation/screens/emergency_hotlines_screen.dart';
import '../../features/utility/presentation/screens/holiday_calendar_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Centralized GoRouter setup for LankaPulse.
/// Employs StatefulShellRoute.indexedStack for persistent bottom tab navigation.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithBottomNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Dashboard Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          // Branch 1: Daily News
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/news',
                builder: (context, state) => const NewsScreen(),
              ),
            ],
          ),
          // Branch 2: Nearby Hospitals
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/hospitals',
                builder: (context, state) => const HospitalsScreen(),
              ),
            ],
          ),
          // Branch 3: Job Board
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/jobs',
                builder: (context, state) => const JobsScreen(),
              ),
            ],
          ),
          // Branch 4: Sinhala Dictionary
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dictionary',
                builder: (context, state) => const DictionaryScreen(),
              ),
            ],
          ),
          // Branch 5: Productivity Hub
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/productivity',
                builder: (context, state) => const ProductivityScreen(),
              ),
            ],
          ),
        ],
      ),
      // Standalone Sub-routes
      GoRoute(
        path: '/document-locker',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const DocumentLockerScreen(),
      ),
      GoRoute(
        path: '/holiday-calendar',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const HolidayCalendarScreen(),
      ),
      GoRoute(
        path: '/emergency-hotlines',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const EmergencyHotlinesScreen(),
      ),
    ],
  );
}

/// Navigation Shell Scaffold holding persistent Bottom Navigation Bar.
class ScaffoldWithBottomNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithBottomNavBar({
    super.key,
    required this.navigationShell,
  });

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.newspaper_outlined),
            selectedIcon: Icon(Icons.newspaper_rounded),
            label: 'News',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_hospital_outlined),
            selectedIcon: Icon(Icons.local_hospital_rounded),
            label: 'Hospitals',
          ),
          NavigationDestination(
            icon: Icon(Icons.work_outline_rounded),
            selectedIcon: Icon(Icons.work_rounded),
            label: 'Jobs',
          ),
          NavigationDestination(
            icon: Icon(Icons.translate_outlined),
            selectedIcon: Icon(Icons.translate_rounded),
            label: 'Dictionary',
          ),
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline_rounded),
            selectedIcon: Icon(Icons.check_circle_rounded),
            label: 'Tasks',
          ),
        ],
      ),
    );
  }
}
