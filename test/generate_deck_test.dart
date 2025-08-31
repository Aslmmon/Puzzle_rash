import 'package:flutter_test/flutter_test.dart';
import 'package:puzzle_rush/domain/entities/level_config.dart';
import 'package:puzzle_rush/domain/respositories/theme_repository.dart';
import 'package:puzzle_rush/domain/usecases/generate_deck.dart';
import 'package:puzzle_rush/domain/entities/memory_card.dart';

class FakeRepository implements ThemeRepository {
  @override
  List<String> labelsForTheme(String themeKey, int neededPairs) {
    return ['🇵🇸', '🕌', '🕋', '📿'].take(neededPairs).toList();
  }
}

void main() {
  group('GenerateDeck', () {
    final repo = FakeRepository();
    final useCase = GenerateDeck(repository: repo);

    test('creates correct number of cards', () {
      final level = LevelConfig(id: 1, rows: 2, cols: 2, themeKey: 'palestine');
      final deck = useCase.call(level);
      expect(deck.length, level.totalCards); // 4 cards
    });

    test('each pair has exactly 2 cards', () {
      final level = LevelConfig(id: 2, rows: 2, cols: 2, themeKey: 'palestine');
      final deck = useCase.call(level);

      // Count cards per pairId
      final pairCounts = <int, int>{};
      for (var card in deck) {
        pairCounts[card.pairId] = (pairCounts[card.pairId] ?? 0) + 1;
      }

      pairCounts.values.forEach((count) {
        expect(count, 2);
      });
    });

    test('throws exception if repository returns fewer labels than needed', () {
      final shortRepo = ShortLabelRepository();
      final useCaseShort = GenerateDeck(repository: shortRepo);
      final level = LevelConfig(id: 3, rows: 4, cols: 4, themeKey: 'palestine');

      expect(() => useCaseShort.call(level), throwsException);
    });
  });
}

// Fake repo that returns too few labels
class ShortLabelRepository implements ThemeRepository {
  @override
  List<String> labelsForTheme(String themeKey, int neededPairs) {
    return ['🇵🇸']; // Only 1 label
  }
}
