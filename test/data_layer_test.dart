import 'package:flutter_test/flutter_test.dart';
import 'package:puzzle_rush/domain/entities/level_config.dart';
import 'package:puzzle_rush/domain/usecases/generate_deck.dart';
import 'package:puzzle_rush/data/repositories/theme_repository_impl.dart';

void main() {
  test('GenerateDeck with ThemeRepositoryImpl', () {
    final repo = ThemeRepositoryImpl();
    final generateDeck = GenerateDeck(repository: repo);

    final level = LevelConfig(id: 1, rows: 2, cols: 2, themeKey: 'palestine');
    final deck = generateDeck(level);

    // Should have 4 cards for 2x2
    expect(deck.length, level.totalCards);

    // Each pair should have 2 cards
    final pairCounts = <int, int>{};
    for (var card in deck) {
      pairCounts[card.pairId] = (pairCounts[card.pairId] ?? 0) + 1;
    }
    pairCounts.values.forEach((count) => expect(count, 2));

    // Print labels (optional)
    print(deck.map((c) => c.label).toList());
  });
}
