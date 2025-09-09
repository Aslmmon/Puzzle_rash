import 'package:codeleek_core/codeleek_core.dart';
import 'package:codeleek_core/ui/widgets/branding_splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:puzzle_rush/presentation/providers/levels_provider.dart';
import 'package:puzzle_rush/presentation/screens/main_menu_screen.dart';
import 'package:puzzle_rush/presentation/screens/level_selection_screen.dart';
import 'package:puzzle_rush/presentation/screens/gameplay_screen.dart';
import 'package:puzzle_rush/presentation/screens/shop_screen.dart';

// AppRouter provider
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RoutePaths.splash,
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        pageBuilder:
            (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: BrandingSplash(
                appName: RoutePaths.AppName,
                onAnimationComplete: () => context.go(RoutePaths.loading),
              ),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return FadeTransition(
                  opacity: CurveTween(
                    curve: Curves.easeInOut,
                  ).animate(animation),
                  child: child,
                );
              },
            ),
      ),
      GoRoute(
        path: RoutePaths.loading,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey, // Important for proper page management
            child: CoreLoadingScreen(
              onInitializationComplete: () {
                context.go(RoutePaths.mainMenu);
              },
            ), // The widget for the target screen
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(
                opacity: CurveTween(
                  curve: Curves.easeInCirc,
                ).animate(animation),
                child: child,
              );
            },
          );
        },
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
