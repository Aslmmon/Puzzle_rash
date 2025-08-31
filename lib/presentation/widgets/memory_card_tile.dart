import 'package:flutter/material.dart';
import '../../domain/entities/memory_card.dart';

class MemoryCardTile extends StatefulWidget {
  final MemoryCard card;
  final VoidCallback onTap;
  final Stream<int> matchedStream;

  const MemoryCardTile({
    super.key,
    required this.card,
    required this.onTap,
    required this.matchedStream,
  });

  @override
  State<MemoryCardTile> createState() => _MemoryCardTileState();
}

class _MemoryCardTileState extends State<MemoryCardTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    widget.matchedStream.listen((pairId) {
      if (widget.card.pairId == pairId) {
        _controller.forward().then((_) => _controller.reverse());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) {
          return Transform.scale(scale: _scale.value, child: child);
        },
        child: Card(
          color:
              widget.card.revealed || widget.card.matched
                  ? Colors.white
                  : Colors.blue,
          child: Center(
            child: Text(
              widget.card.revealed || widget.card.matched
                  ? widget.card.label
                  : '?',
              style: const TextStyle(fontSize: 32),
            ),
          ),
        ),
      ),
    );
  }
}
