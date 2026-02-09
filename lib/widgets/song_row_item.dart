import 'package:flutter/material.dart';
import 'package:music_app/models/song.dart';
import 'package:music_app/provider/play_provider.dart';
import 'package:music_app/provider/songs_provider.dart';
import 'package:provider/provider.dart';

class SongRowItem extends StatelessWidget {
  final String index;
  final String title;
  final String subtitle;
  final String imageUrl;
  final bool isLiked;
  final Song song;

  final Color? color;
  final VoidCallback? fct;
  final bool? add;


  const SongRowItem({
    super.key,
    required this.index,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.isLiked,
    this.color,
    this.fct,
    this.add, 
    required this.song
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final songsProvider = context.watch<SongsProvider>();

  bool whiteText = (color!=null);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          GestureDetector(
                              onTap: () {
                                // Handle song tap
                                print('object');
                                 context.read<PlayerProvider>().playSong(
          songsProvider.songs, // your queue
          songsProvider.songs.indexOf(song),
              );
              songsProvider.fetchMostPlayedSongs();
              songsProvider.fetchRecentlyPlayedSongs();

                              },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: 62,
                height: 62,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
      
          /// TEXT + MORE ICON
          Expanded(
            child: Row(
              children: [
                /// TEXT SIDE (constrained)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:whiteText ? Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white) : Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if(isLiked)
                          Icon(
                            Icons.favorite,
                            size: 14,
                            color: whiteText ? Colors.white : cs.onPrimary,
                          )else
                          Container(),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: whiteText ? Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white) : Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
      
                const SizedBox(width: 8),
              whiteText?Container():
                /// MORE ICON (fixed size)
                (add==true)?
                GestureDetector(
                  onTap: fct,
                  child: Icon(
                    Icons.add,
                    size: 20,
                    color: cs.onPrimary,
                  ),
                ):GestureDetector(
                  onTap: fct,
                  child: Icon(
                    Icons.more_horiz,
                    size: 20,
                    color: cs.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
