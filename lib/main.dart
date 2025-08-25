import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:puzzle_rush/presentation/screens/splash_screen.dart';

// You might need to import your splash screen later here
// import 'splash_screen.dart';

/// The main entry point of the application.
///
/// Initializes the Flutter application and runs the [MyApp] widget.
void main() {
  // If you need to initialize Firebase or other async services before runApp,
  // ensure widgets binding is initialized and then initialize them.
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(); // Example for Firebase

  runApp(
    // Wrap your app with ProviderScope for Riverpod state management
    const ProviderScope(child: MyApp()),
  );
}

/// The root widget of the Puzzle Rush application.
///
/// This widget sets up the [MaterialApp] with the title, theme,
/// and the initial screen ([SplashScreen]).
class MyApp extends StatelessWidget {
  /// Creates an instance of [MyApp].
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Puzzle Rush',
      theme: ThemeData(
        primarySwatch: Colors.blue, // You can customize your theme
      ),
      // For now, let's put a placeholder.
      // You'll replace this with your SplashScreen in Day 2.
      home: const SplashScreen(), // <-- CHANGE THIS
      debugShowCheckedModeBanner: false, // O
    );
  }
}
