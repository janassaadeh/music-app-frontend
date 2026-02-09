import 'package:flutter/material.dart';

class TestWidget extends StatelessWidget{
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return   Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Text('Left'),
                const SizedBox(width: 12),
                const Icon(Icons.circle, size: 12),
                const Spacer(),
                const Text('Right'),
                const SizedBox(width: 8),
                FilledButton(onPressed: () {}, child: const Text('Action')),
              ],
            ),
          );
  }

}
