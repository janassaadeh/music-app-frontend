import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: cs.primaryContainer),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Menu',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: cs.onPrimaryContainer,
                  ),
                ),
              ),
            ),
            const ListTile(leading: Icon(Icons.home), title: Text('Home')),
            const ListTile(leading: Icon(Icons.grid_view), title: Text('Grid')),
            const ListTile(leading: Icon(Icons.list), title: Text('List')),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
    );
  }
}
