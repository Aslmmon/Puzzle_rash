// lib/routes/app_router.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:puzzle_rush/presentation/screens/controllers/splash_controller.dart';
import 'package:puzzle_rush/presentation/screens/level_selection_screen.dart';
import 'package:puzzle_rush/presentation/screens/loading_screen.dart'
    show LoadingScreen, appInitializationProvider;
import 'package:puzzle_rush/presentation/screens/main_menu_screen.dart';
import 'package:puzzle_rush/presentation/screens/splash_screen.dart'
    show SplashScreen;

/// A provider that exposes the app-wide GoRouter instance.
/// Keeps navigation declarative & testable.
final appRouterProvider = Provider<GoRouter>((ref) {
  final splashTarget = ref.watch(splashTargetProvider);
  final initState = ref.watch(appInitializationProvider);

  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/loading',
        builder: (context, state) => const LoadingScreen(),
      ),
      GoRoute(
        path: '/main-menu',
        builder: (context, state) => const MainMenuScreen(),
      ),
      GoRoute(
        path: '/level-selection',
        builder: (context, state) => const LevelSelectionScreen(),
      ),
    ],
    redirect: (context, state) {
      // Wait until splash provider finishes
      if (splashTarget.isLoading) return null;
      final splashRoute = splashTarget.maybeWhen(
        data: (target) {
          switch (target) {
            case SplashTarget.loading:
              return '/loading';
            case SplashTarget.onboarding:
              return '/onboarding';
          }
        },
        orElse: () => null,
      );

      // Initialization handling
      if (initState.isLoading) return '/loading';
      if (initState.hasError) return '/error';
      if (initState.hasValue) return '/main-menu';

      return null;
    },
  );
});
