import 'package:flutter_test/flutter_test.dart';
import 'package:puzzle_rush/domain/entities/memory_card.dart';

void main() {
  group('MemoryCard', () {
    final card = MemoryCard(pairId: 1, label: '🇵🇸');

    test('initial state', () {
      expect(card.revealed, false);
      expect(card.matched, false);
      expect(card.label, '🇵🇸');
      expect(card.pairId, 1);
    });

    test('reveal() sets revealed=true', () {
      final revealedCard = card.reveal();
      expect(revealedCard.revealed, true);
      expect(revealedCard.matched, false);
    });

    test('hide() sets revealed=false', () {
      final hiddenCard = card.reveal().hide();
      expect(hiddenCard.revealed, false);
      expect(hiddenCard.matched, false);
    });

    test('match() sets matched=true and revealed=true', () {
      final matchedCard = card.match();
      expect(matchedCard.matched, true);
      expect(matchedCard.revealed, true);
    });
  });
}
