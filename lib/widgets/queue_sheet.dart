import 'package:flutter/material.dart';

class QueueSheet extends StatelessWidget {
  final List<Map<String, String>> songs;
  final int currentIndex;
  final Function(int) playSong;
  final Function(List<Map<String, String>>) updateQueue;

  QueueSheet({
    required this.songs,
    required this.currentIndex,
    required this.playSong,
    required this.updateQueue,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.circular(5))),
              const SizedBox(height: 10),
              const Text("Up Next", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Expanded(
                child: ReorderableListView.builder(
                  itemCount: songs.length,
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > oldIndex) newIndex -= 1;
                    final item = songs.removeAt(oldIndex);
                    songs.insert(newIndex, item);
                    updateQueue(songs);
                  },
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    final isCurrent = index == currentIndex;
                    return ListTile(
                      key: ValueKey(song["url"]),
                      leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(song["album_cover"]!, width: 50, height: 50, fit: BoxFit.cover)),
                      title: Text(song["title"]!, style: const TextStyle(color: Colors.white)),
                      subtitle: Text(song["artist"]!, style: const TextStyle(color: Colors.white70)),
                      trailing: isCurrent ? const Icon(Icons.play_arrow, color: Colors.white) : null,
                      onTap: () {
                        playSong(index);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
