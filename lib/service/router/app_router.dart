import 'package:codeleek_core/codeleek_core.dart';
import 'package:codeleek_core/core/utils/app_constants.dart';
import 'package:codeleek_core/ui/widgets/branding_splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:puzzle_rush/presentation/providers/levels_provider.dart';
import 'package:puzzle_rush/presentation/screens/main_menu_screen.dart';
import 'package:puzzle_rush/presentation/screens/level_selection_screen.dart';
import 'package:puzzle_rush/presentation/screens/gameplay_screen.dart';
import 'package:puzzle_rush/presentation/screens/shop_screen.dart';
import 'package:puzzle_rush/presentation/utils/AppConstants.dart';

// AppRouter provider
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RoutePaths.splash,
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        pageBuilder:
            (context, state) => buildPageWithSlideTransition(
              context: context,
              state: state,
              child: CoreSplash(
                appName: AppConstants.appName,
                onAnimationComplete: () => context.go(RoutePaths.loading),
              ),
            ),
      ),
      GoRoute(
        path: RoutePaths.loading,
        pageBuilder:
            (context, state) => buildPageWithSlideTransition(
              context: context,
              state: state,
              child: CoreLoadingScreen(
                onInitializationComplete: () => context.go(RoutePaths.mainMenu),
              ),
            ),
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
  static const AppName = 'Memory Rush';
}

CustomTransitionPage<T> buildPageWithSlideTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Use a slide transition that comes in from the right
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0), // Start from the right side
          end: Offset.zero, // End at the center
        ).animate(animation),
        child: child,
      );
    },
  );
}
