import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flow/core/services/user_profile_service.dart';
import 'package:flow/features/home/presentation/screens/home_screen.dart';
import 'package:flow/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:flow/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:flow/features/people/presentation/screens/people_screen.dart';
import 'package:flow/features/settings/presentation/screens/settings_screen.dart';
import 'package:flow/features/statistics/presentation/screens/statistics_screen.dart';

/// Scaffold with bottom navigation bar for the main app shell
class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Personas',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Estadísticas',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Ajustes',
          ),
        ],
      ),
    );
  }
}

/// GoRouter configuration for the app
final router = GoRouter(
  initialLocation: '/welcome',
  redirect: (context, state) {
    final userProfile = UserProfileService.instance;
    final needsOnboarding = userProfile.needsOnboarding();
    final location = state.matchedLocation;
    final isPreHomeRoute = location == '/welcome' || location == '/onboarding';

    // First launch: send the user to the welcome screen (which in turn
    // lets them choose between starting onboarding or importing a backup).
    if (needsOnboarding && !isPreHomeRoute) {
      return '/welcome';
    }

    // Profile already complete — don't let the user land back on the
    // welcome/onboarding flow.
    if (!needsOnboarding && isPreHomeRoute) {
      return '/home';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        // Home branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // People branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/people',
              builder: (context, state) => const PeopleScreen(),
            ),
          ],
        ),
        // Statistics branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/statistics',
              builder: (context, state) => const StatisticsScreen(),
            ),
          ],
        ),
        // Settings branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
