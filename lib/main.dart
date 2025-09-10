import 'package:codeleek_core/ads/provider.dart';
import 'package:codeleek_core/core/config/core_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:puzzle_rush/presentation/providers/storageProvider.dart';
import 'package:puzzle_rush/presentation/screens/loading_screen.dart';
import 'package:puzzle_rush/presentation/screens/splash_screen.dart';
import 'package:puzzle_rush/service/router/app_router.dart';

// You might need to import your splash screen later here
// import 'splash_screen.dart';

/// The main entry point of the application.
///
/// Initializes the Flutter application and runs the [MyApp] widget.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitDown,
  ]);
  final coreConfig = CoreConfig(
    admobAppId: 'ca-app-pub-3940256099942544~3347511713',
    admobInterstitialAdUnitId: 'ca-app-pub-3940256099942544/1033173712',
    admobRewardedAdUnitId: 'ca-app-pub-3940256099942544/5224354917',
    admobBannerAdUnitId: 'ca-app-pub-3940256099942544/6300978111',
  );

  runApp(
    ProviderScope(
      overrides: [coreConfigProvider.overrideWithValue(coreConfig)],
      child: const AppInitializer(),
    ),
  );
}

class AppInitializer extends ConsumerWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the future provider for SharedPreferences
    final sharedPrefs = ref.watch(sharedPreferencesProvider);

    return sharedPrefs.when(
      data: (_) => const MyApp(),
      loading: () => const MaterialApp(home: LoadingScreen()),
      error:
          (err, stack) => const MaterialApp(
            home: Scaffold(
              body: Center(child: Text('Error: Could not load app data.')),
            ),
          ),
    );
  }
}

/// The root widget of the Puzzle Rush application.
///
/// This widget sets up the [MaterialApp] with the title, theme,
/// and the initial screen ([SplashScreen]).
class MyApp extends ConsumerWidget {
  /// Creates an instance of [MyApp].
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Puzzle Rush',
      theme: ThemeData(
        primarySwatch: Colors.blue, // You can customize your theme
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false, // O
    );
  }
}
