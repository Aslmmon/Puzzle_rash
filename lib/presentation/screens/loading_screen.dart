import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingScreen extends ConsumerWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Loading...'),
          ],
        ),
      ),
    );
  }
}

/// Provider to simulate app initialization tasks
final appInitializationProvider = FutureProvider<void>((ref) async {
  // Simulate loading tasks (Firebase, ads, assets, etc.)
  await SharedPreferences.getInstance();
  print("SharedPreferences initialized");


  await Future.delayed(const Duration(seconds: 1)); // Firebase init
  print("Firebase initialized (simulated)");

  await Future.delayed(const Duration(seconds: 1)); // Ads init
  print("Ads initialized (simulated)");

  await Future.delayed(const Duration(seconds: 1)); // Other assets
  print("Other assets loaded (simulated)");
});
