import 'package:flutter/material.dart';

class Tags extends StatefulWidget {
  const Tags({super.key});

  @override
  State<Tags> createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  // Track the currently selected tag
  String selectedTag = 'Playlists';

  final List<String> options = ['Playlists', 'Albums', 'Artists'];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Wrap(
      spacing: 8.0, // Gap between adjacent chips
      children: options.map((String label) {
        bool isSelected = selectedTag == label;

        return ChoiceChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (bool selected) {
            setState(() {
              selectedTag = label;
            });
          },
          // Text Style
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 13
          ),
          // Colors
          selectedColor: const Color(0xFFFF00FF), // Vibrant Magenta
          backgroundColor: const Color(0xFFF0F1F4), // Light Grey
          // Border and Shape
          shape: StadiumBorder(
            side: BorderSide(
              color: isSelected ? const Color(0xFFFF00FF) : Colors.transparent,
            ),
          ),
          // Remove default padding/shadows to match the flat UI look
          pressElevation: 0,
          showCheckmark: false, 
        );
      }).toList(),
    );
  }
}