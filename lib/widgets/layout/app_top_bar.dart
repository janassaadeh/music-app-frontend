import 'package:flutter/material.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AppBar(
      backgroundColor: cs.primary,
      foregroundColor: cs.onPrimary,
      centerTitle: false,
      title: const Text('More on Flutter Layouts'),
      actions: [
        IconButton(
          tooltip: 'Search',
          onPressed: () {},
          icon: const Icon(Icons.search),
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: cs.onPrimary), // 3-dots icon
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'notifications', child: Text('Notifications')),
            PopupMenuItem(value: 'settings', child: Text('Settings')),
            PopupMenuDivider(),
            PopupMenuItem(value: 'profile', child: Text('Profile')),
            PopupMenuItem(value: 'logout', child: Text('Logout')),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
