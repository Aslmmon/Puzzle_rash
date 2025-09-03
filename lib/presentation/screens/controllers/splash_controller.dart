import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Where the app should go after the splash completes.
enum SplashTarget { loading, onboarding }

/// Provider that decides the splash target after delay/startup tasks.
final splashTargetProvider = FutureProvider<SplashTarget>((ref) async {
  // Simulate minimal work + delay.
  await Future.delayed(const Duration(seconds: 2));
  // TODO: add real logic: check if first run, user logged in, etc.
  return SplashTarget.loading;
});
