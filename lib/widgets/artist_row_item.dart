import 'package:flutter/material.dart';

class ArtistRowItem extends StatelessWidget {
  final String name;
  final String imageUrl;
  final VoidCallback? onTap;

  const ArtistRowItem({
    super.key,
    required this.name,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
              child: imageUrl.isEmpty ? const Icon(Icons.person, size: 40) : null,
            ),
            const SizedBox(width: 15),
            Text(
              name,
              style: Theme.of(context).textTheme.labelSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
