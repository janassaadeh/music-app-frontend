import 'package:flutter/material.dart';

class AppBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const AppBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onSelected,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.explore), label: 'Explore'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.library_music), label: 'Library'),
          // NavigationDestination(icon: Icon(Icons.library_music), label: 'Play'),

        ],
        indicatorColor: Colors.transparent,
       
      ),
    );
  }
}
