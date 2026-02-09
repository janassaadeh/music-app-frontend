import 'package:flutter/material.dart';
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

class PlaylistPage extends StatefulWidget {
  final Playlist? playlist;

  const PlaylistPage({super.key, required this.playlist});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
      final songsProvider = context.watch<SongsProvider>();
    final artistsProvider = context.watch<ArtistsProvider>();
    final albumProvider = context.watch<AlbumProvider>();
                       final recommendedLikedSongs = songsProvider.songs;
                       List<Song>songs=widget.playlist?.songs ?? [];
                       int position =songs.length;
                       bool edit=false;
    // .where((likedSong) =>
    //     !playlist!.songs.any((pSong) => pSong.id == likedSong.id))
    // .toList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "",
        onBackTap: () => pop(context), // Uses your pop function
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(21),        child: 
            Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Container(
            //         decoration: BoxDecoration(
            //           color: cs.surfaceContainerLow,
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //         padding: const EdgeInsets.symmetric(horizontal: 12),
            //         child: TextField(
            //           decoration: InputDecoration(
            //             icon: Icon(Icons.search, color: cs.onSurfaceVariant, size: 20),
            //             hintText: 'Search...',
            //             hintStyle: Theme.of(context).textTheme.bodySmall,
            //             border: InputBorder.none,
            //           ),
            //         ),
            //       ),
                  // SizedBox(height: 25,),
                  Row(
                    children: [
                      Container(
                        width: 130, height: 130,
                        decoration: BoxDecoration(
                          color: Colors.blue[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:Icon(Icons.music_note, color: Colors.blue[100], size: 40,), ),
                    SizedBox(width:20),
                    Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                          
                            children: [
                            Text(widget.playlist!.name, style: Theme.of(context).textTheme.bodyMedium,),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text("${widget.playlist!.songs.length} songs", style: Theme.of(context).textTheme.bodySmall,),
                              // SizedBox(width: 4),
                              // Icon(Icons.circle, size: 4, color: cs.onPrimary,),
                              // SizedBox(width: 4),
                              // Text("By you", style: Theme.of(context).textTheme.bodySmall,),
                            ],
                          ),
                          SizedBox(height: 80,)
                            ],
                          ),
                    ]
                    
                    ,
                  ),
                  SizedBox(height: 25,),
                  
                  Row(
                    children: [
                      CustomRoundedButton(title: "SHUFFLE PLAY", width: 170, height: 40, color: cs.primary, textColor: Colors.white, onTap: (){},fontSize: 13,),
                    SizedBox(width:20),
                      CustomRoundedButton(title: "EDIT", width: 170, height: 40, color: cs.primaryContainer, textColor: Colors.black, onTap: (){

                        setState(() {
                          edit=true;
                        });
                      },fontSize: 13,),
                    
                    ],
                  ),
                  SizedBox(height: 25,),
                   if (widget.playlist!.songs.isNotEmpty) ...[
                            
                            const SizedBox(height: 8),
                            ...songs.map((s) {
                              final artist = artistsProvider.artistsMap[s.artistId];
                              final album = albumProvider.albumsMap[s.albumId];
                              return SongRowItem(
                                index: songs.indexOf(s).toString(),
                                title: s.title,
                                subtitle:
                                    '${artist?.name ?? "Unknown Artist"} • ${album?.title ?? "Unknown Album"}',
                                imageUrl: album?.coverImageUrl ?? 'https://i.pinimg.com/1200x/2a/86/a5/2a86a560f0559704310d98fc32bd3d32.jpg',
                                isLiked: widget.playlist!.songs.any((song) => song.id == s.id),
                                song: s,
                                
                              );
                            }),
                          ],
        
                  SizedBox(height: 25,),
                              Text("Recommended songs", style: Theme.of(context).textTheme.bodyMedium,),



if (recommendedLikedSongs.isNotEmpty) ...[
  const SizedBox(height: 8),
  ...recommendedLikedSongs.map((s) {

                              final artist = artistsProvider.artistsMap[s.artistId];
                              final album = albumProvider.albumsMap[s.albumId];
                              return SongRowItem(
                                song: s,
                                index: recommendedLikedSongs.indexOf(s).toString(),
                                title: s.title,
                                subtitle:
                                    '${artist?.name ?? "Unknown Artist"} • ${album?.title ?? "Unknown Album"}',
                                imageUrl: album?.coverImageUrl ?? 'https://i.pinimg.com/1200x/2a/86/a5/2a86a560f0559704310d98fc32bd3d32.jpg',
                                isLiked: recommendedLikedSongs.any((song) => song.id == s.id),
                                add: true,
                              fct: () async {
  await PlaylistService().addSongToPlaylist(
    playlistId: widget.playlist!.id,
    songId: s.id,
    position: widget.playlist!.songs.length
  );
  print("added to playlist");
  setState(() {
    songs.add(s);
    position++;
    recommendedLikedSongs.removeWhere((song) => song.id == s.id);
  });
  await context.read<PlaylistProvider>().fetchPlaylists();
},

        
                              );
                            }),
                          ],
        
              
            ],
            ),
        ),
      ),
    );
  }
}