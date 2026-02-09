import 'package:flutter/material.dart';
import 'package:music_app/provider/play_provider.dart';
import 'package:music_app/provider/album_provider.dart';
import 'package:music_app/provider/artists_provider.dart';
import 'package:music_app/widgets/song_row_item.dart';
import 'package:provider/provider.dart';

class QueueView extends StatelessWidget {
  const QueueView({super.key});

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    final queue = player.queue;
    final currentIndex = player.currentIndex;

    final artistsProvider = context.watch<ArtistsProvider>();
    final albumProvider = context.watch<AlbumProvider>();

    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Up Next",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: queue.length,
              itemBuilder: (context, index) {
                final song = queue[index];
                final artist = artistsProvider.artistsMap[song.artistId];
                final album = albumProvider.albumsMap[song.albumId];

                return GestureDetector(
                  onTap: () {
                    // Play the tapped song
                    player.playSong(queue, index);
                  },
                  child: SongRowItem(
                    song: song,
                    index: (index + 1).toString(),
                    color:Colors.white,
                    title: song.title,
                    subtitle:
                        '${artist?.name ?? "Unknown Artist"} • ${album?.title ?? "Unknown Album"}',
                    imageUrl: album?.coverImageUrl ??
                        'https://i.pinimg.com/1200x/2a/86/a5/2a86a560f0559704310d98fc32bd3d32.jpg',
                    isLiked: player.queue.any((s) => s.id == song.id),
                    // highlight: index == currentIndex, // optional: highlight current song
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
