import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Where the app should go after the splash completes.
enum SplashTarget { loading }

/// Provider that decides the splash target after delay/startup tasks.
final splashTargetProvider = FutureProvider<SplashTarget>((ref) async {
  // Simulate minimal work + delay.
  await Future.delayed(const Duration(seconds: 2));
  return SplashTarget.loading;
});
