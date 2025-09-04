// lib/presentation/providers/rewarded_ad_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:puzzle_rush/data/cache/progress_storage.dart';
import 'package:puzzle_rush/presentation/providers/storageProvider.dart';

// The provider that holds the state of the rewarded ad (null if not loaded)
final rewardedAdControllerProvider =
    StateNotifierProvider<RewardedAdController, RewardedAd?>((ref) {
      return RewardedAdController(ref.read(progressStorageProvider));
    });

class RewardedAdController extends StateNotifier<RewardedAd?> {
  final ProgressStorage storage;
  final String _adUnitId =
      'ca-app-pub-3940256099942544/5224354917'; // Test Ad Unit ID

  RewardedAdController(this.storage) : super(null) {
    _loadAd();
  }

  void _loadAd() {
    RewardedAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          state = ad;
          print('Rewarded ad loaded.');
        },
        onAdFailedToLoad: (error) {
          state = null;
          print('Failed to load rewarded ad: $error');
        },
      ),
    );
  }

  void showAd() {
    if (state == null) {
      print('Warning: Rewarded ad not loaded.');
      return;
    }

    state!.show(
      onUserEarnedReward: (ad, reward) {
        // This is the most important part: the reward logic.
        // We'll award 200 coins for watching the ad.
        storage.addCoins(200);
        print('User earned reward of ${reward.amount} ${reward.type}');
      },
    );

    state!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadAd(); // Load a new ad after the current one is dismissed
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _loadAd(); // Load a new ad if the current one fails to show
      },
    );

    state = null; // Clear the state so the UI knows the ad is gone
  }
}
