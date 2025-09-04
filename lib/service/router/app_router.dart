import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:puzzle_rush/presentation/providers/levels_provider.dart';
import 'package:puzzle_rush/presentation/screens/controllers/splash_controller.dart';
import 'package:puzzle_rush/presentation/screens/loading_screen.dart';
import 'package:puzzle_rush/presentation/screens/main_menu_screen.dart';
import 'package:puzzle_rush/presentation/screens/level_selection_screen.dart';
import 'package:puzzle_rush/presentation/screens/gameplay_screen.dart';
import 'package:puzzle_rush/presentation/screens/shop_screen.dart';
import 'package:puzzle_rush/presentation/screens/splash_screen.dart';

// AppRouter provider
final appRouterProvider = Provider<GoRouter>((ref) {
  final splashState = ref.watch(splashTargetProvider);
  final initState = ref.watch(appInitializationProvider);

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
        path: RoutePaths.shop,
        builder: (context, state) => const ShopScreen(),
      ),
      GoRoute(
        path: RoutePaths.gameplay,
        builder: (context, state) {
          final levelId = int.parse(state.pathParameters['levelId']!);
          final level = ref.read(levelsProvider.notifier).getLevelById(levelId);
          return GameplayScreen(level: level);
        },
      ),
    ],
    redirect: (context, state) {
      final isSplash = state.matchedLocation == RoutePaths.splash;
      final isLoading = state.matchedLocation == RoutePaths.loading;

      // Handle the splash screen state
      if (isSplash) {
        if (splashState.isLoading) return null;
        if (splashState.hasError) return RoutePaths.loading;
        return RoutePaths.loading;
      }

      // Handle the loading screen state
      if (isLoading) {
        if (initState.isLoading) return null; // Stay on loading screen
        if (initState.hasError) {
          return RoutePaths.mainMenu; // Or an error screen
        }
        return RoutePaths.mainMenu;
      }

      return null;
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
