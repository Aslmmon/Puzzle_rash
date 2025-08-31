class MemoryCard {
  final int pairId; // Two cards with the same pairId match
  final String label; // Emoji, text, or asset key
  final bool revealed; // Is the card currently flipped?
  final bool matched; // Is the card already matched?

  const MemoryCard({
    required this.pairId,
    required this.label,
    this.revealed = false,
    this.matched = false,
  });

  /// Returns a new card with revealed=true
  MemoryCard reveal() => MemoryCard(
    pairId: pairId,
    label: label,
    revealed: true,
    matched: matched,
  );

  /// Returns a new card with revealed=false
  MemoryCard hide() => MemoryCard(
    pairId: pairId,
    label: label,
    revealed: false,
    matched: matched,
  );

  /// Returns a new card with matched=true
  MemoryCard match() =>
      MemoryCard(pairId: pairId, label: label, revealed: true, matched: true);
}
