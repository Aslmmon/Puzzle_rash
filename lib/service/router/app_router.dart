// lib/routes/app_router.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:puzzle_rush/presentation/providers/levels_provider.dart';
import 'package:puzzle_rush/presentation/screens/controllers/splash_controller.dart';
import 'package:puzzle_rush/presentation/screens/loading_screen.dart';
import 'package:puzzle_rush/presentation/screens/main_menu_screen.dart';
import 'package:puzzle_rush/presentation/screens/level_selection_screen.dart';
import 'package:puzzle_rush/presentation/screens/gameplay_screen.dart';
import 'package:puzzle_rush/presentation/screens/splash_screen.dart';

// AppRouter provider
final appRouterProvider = Provider<GoRouter>((ref) {
  final initState = ref.watch(appInitializationProvider);
  final splashState = ref.watch(splashTargetProvider);

  return GoRouter(
    initialLocation: RoutePaths.splash,
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.loading,
        builder: (context, state) => const LoadingScreen(),
      ),
      GoRoute(
        path: RoutePaths.mainMenu,
        builder: (context, state) => const MainMenuScreen(),
      ),
      GoRoute(
        path: RoutePaths.levelSelection,
        builder: (context, state) => const LevelSelectionScreen(),
      ),
      GoRoute(
        path: RoutePaths.gameplay,
        builder: (context, state) {
          final levelId = state.pathParameters['levelId']!;
          // Here you could fetch the LevelConfig via provider if needed
          print("$levelId level is $levelId ");
          final level = ref
              .read(levelsProvider)
              .firstWhere(
                (l) => l.id == levelId,
            orElse: () => ref.read(levelsProvider).first,
          );
          return GameplayScreen(level: level);
        },
      ),
    ],
    redirect: (context, state) {
      //Splash State
      if (state.matchedLocation == RoutePaths.splash) {
        return splashState.when(
          data: (target) {
            switch (target) {
              case SplashTarget.loading:
                return RoutePaths.loading; // redirect to loading
            }
          },
          loading: () => null, // still waiting, stay on splash
          error:
              (e, _) => RoutePaths.loading, // optional: go to loading on error
        );
      }

      if (state.matchedLocation == RoutePaths.loading) {
        if (initState.isLoading) return RoutePaths.loading;
        if (initState.hasError) {
          return RoutePaths.loading; // Could make /error later
        }
        if (initState.hasValue) return RoutePaths.mainMenu;
      }
      // Redirect to /loading until initialization completes

      return null; // default
    },
  );
});

// lib/routes/route_paths.dart
class RoutePaths {
  static const splash = '/splash';
  static const loading = '/loading';
  static const mainMenu = '/main-menu';
  static const levelSelection = '/level-selection';
  static const gameplay = '/gameplay/:levelId';
  static const dailyPuzzle = '/daily-puzzle';
  static const shop = '/shop';
  static const settings = '/settings';
}
