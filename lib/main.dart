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
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(
      // Wrap your app with ProviderScope for Riverpod state management
      const ProviderScope(child: AppInitializer()),
    );
  });
}

class AppInitializer extends ConsumerWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the future provider for SharedPreferences
    final sharedPrefs = ref.watch(sharedPreferencesProvider);

    return sharedPrefs.when(
      // When the future is resolved, show your main app
      data: (_) => const MyApp(),
      // While it's loading, show a loading screen
      loading: () => const MaterialApp(home: LoadingScreen()),
      // If there's an error, handle it gracefully
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
