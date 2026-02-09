import 'package:flutter/material.dart';

class TwoCards extends StatelessWidget {
  final bool vertical;
  const TwoCards({super.key, required this.vertical});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final cardA = Card(
      color: cs.primaryContainer,
      child: const SizedBox(height: 120, child: Center(child: Text('Card 1'))),
    );

    final spacer = const SizedBox(width: 16, height: 16);

    final cardB = Card(
      color: cs.secondaryContainer,
      child: const SizedBox(height: 120, child: Center(child: Text('Card 2'))),
    );

    return vertical
        ? Column(children: [cardA, spacer, cardB])
        : Row(children: [cardA, spacer, cardB]);
  }
}
