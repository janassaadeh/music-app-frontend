import 'package:flutter/material.dart';

class SongOptionsSheet extends StatelessWidget {
  const SongOptionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      // White background with rounded top corners
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Song Header Section
          Container(

             decoration: BoxDecoration(
 color: cs.primaryContainer,        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  
                  // const SizedBox(width: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network("https://upload.wikimedia.org/wikipedia/en/5/5c/Moral_of_the_Story_-_Ashe.jpg", width: 62, height: 62, fit: BoxFit.cover),
                 
                  ),
                  
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Moral of the Story", style: Theme.of(context).textTheme.labelSmall),
                        const SizedBox(height: 2),
                        Text("Ashe", style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text("100 Likes", style: Theme.of(context).textTheme.bodySmall),
                            SizedBox(width: 4),
                    
                            Icon(Icons.circle, size: 4, color: cs.onPrimary),
                            SizedBox(width: 4),
                            Text("1K Plays", style: Theme.of(context).textTheme.bodySmall),

                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Options List
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                _buildOption(context, Icons.favorite, "Liked", color: Colors.black),
                _buildOption(context, Icons.playlist_add, "Add to playlist"),
                _buildOption(context, Icons.skip_next_outlined, "Play next"),
                _buildOption(context, Icons.queue_music, "Add to queue"),
                _buildOption(context, Icons.mic_external_on, "Go to Artist"),
                _buildOption(context, Icons.album_outlined, "Go to Album"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, IconData icon, String label, {Color? color}) {
    final cs = Theme.of(context);
    
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black87),
      title: Text(
        label,
        style: cs.textTheme.bodySmall),
      onTap: () {
        // Handle action
      },
    );
  }
}