import 'package:flutter/material.dart';
import 'package:music_app/models/album.dart';
import 'package:music_app/models/playlist.dart';
import 'package:music_app/models/song.dart';
import 'package:music_app/provider/album_provider.dart';
import 'package:music_app/provider/artists_provider.dart';
import 'package:music_app/provider/play_provider.dart';
import 'package:music_app/provider/playlist_provider.dart';
import 'package:music_app/provider/songs_provider.dart';
import 'package:music_app/services/playlist_service.dart';
import 'package:music_app/utils/shorcuts.dart' show pop, push;
import 'package:music_app/widgets/custom_rounded_button.dart';
import 'package:music_app/widgets/layout/app_bar.dart';
import 'package:music_app/widgets/song_row_item.dart';
import 'package:provider/provider.dart';
class AlbumPage extends StatefulWidget {
  final Album? album;

  const AlbumPage({super.key, required this.album});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final songsProvider = context.watch<SongsProvider>();
    final artistsProvider = context.watch<ArtistsProvider>();
    final albumProvider = context.watch<AlbumProvider>();

    // Get songs for this album
    final albumSongs = songsProvider.songs
        .where((song) => song.albumId == widget.album!.id)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "",
        onBackTap: () => pop(context),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(21),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.album!.coverImageUrl,
                      fit: BoxFit.cover,
                      width: 150,
                      height: 150,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,

                      children: [
                        Text(
                          widget.album!.title,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "${albumSongs.length} songs",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            // const SizedBox(width: 4),
                            // Icon(Icons.circle, size: 4, color: cs.onPrimary),
                            // const SizedBox(width: 4),
                            // Text(
                            //   "By ${widget.album!.artistName}",
                            //   style: Theme.of(context).textTheme.bodySmall,
                            // ),

                          ],
                        ),
                          SizedBox(height: 80,)

                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomRoundedButton(title: "SHUFFLE PLAY", width: 250, height: 40, color: cs.primary, textColor: Colors.white, onTap: (){},fontSize: 13,),

                       
                   
                    
                    ],
                  ),
              const SizedBox(height: 25),

              // Songs List
              if (albumSongs.isNotEmpty) ...[
                ...albumSongs.map((song) {
                  final artist = artistsProvider.artistsMap[song.artistId];
                  final album = albumProvider.albumsMap[song.albumId];
                  return GestureDetector(
                    onTap: () {
                      context.read<PlayerProvider>().playSong(
                            albumSongs,
                            albumSongs.indexOf(song),
                          );
                    },
                    child: SongRowItem(
                      index: (albumSongs.indexOf(song) + 1).toString(),
                      title: song.title,
                      subtitle:
                          '${artist?.name ?? "Unknown Artist"} • ${album?.title ?? "Unknown Album"}',
                      imageUrl: album?.coverImageUrl ??
                          'https://i.pinimg.com/1200x/2a/86/a5/2a86a560f0559704310d98fc32bd3d32.jpg',
                      isLiked:
                          songsProvider.likedSongs.any((s) => s.id == song.id),
                      song: song,
                    ),
                  );
                }),
              ] else
                Center(
                  child: Text("No songs in this album"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
