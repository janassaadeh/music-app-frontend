import 'package:flutter/material.dart';

class ListTab extends StatelessWidget {
  const ListTab({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          '4) ListView.builder (repeating items)',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        ListView.builder(
          itemCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, i) => Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: cs.primaryContainer,
                child: Text('${i + 1}'),
              ),
              title: Text('List item ${i + 1}'),
              subtitle: const Text('This subtitle explains the item briefly.'),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
        ),
      ],
    );
  }
}
