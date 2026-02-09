import 'package:flutter/material.dart';
import 'package:music_app/provider/album_provider.dart';
import 'package:music_app/provider/artists_provider.dart';
import 'package:music_app/provider/play_provider.dart';
import 'package:music_app/provider/songs_provider.dart';
import 'package:music_app/services/song_service.dart';
import 'package:music_app/utils/color_pick.dart';
import 'package:music_app/widgets/full_player.dart';
import 'package:music_app/widgets/mini_player.dart';
import 'package:provider/provider.dart';

class GlobalPlayerWidget extends StatefulWidget {
  const GlobalPlayerWidget({super.key});

  @override
  State<GlobalPlayerWidget> createState() => _GlobalPlayerWidgetState();
}

class _GlobalPlayerWidgetState extends State<GlobalPlayerWidget> {
  double albumCoverSize = 350.0;
  bool showQueue = false;

  @override
  Widget build(BuildContext context) {
    final player = context.watch<PlayerProvider>();
    final song = player.currentSong;

    final artistsProvider = context.watch<ArtistsProvider>();
    final albumProvider = context.watch<AlbumProvider>();
    final songsProvider = context.watch<SongsProvider>();

  if (song == null) return Container(

);


    final artist = artistsProvider.artistsMap[song.artistId];
    final album = albumProvider.albumsMap[song.albumId];

    // check if song is liked
    var isLiked = songsProvider.likedSongs.any((s) => s.id == song.id);
  return FutureBuilder<Color>(
      future: getColorFromImageUrl(album?.coverImageUrl ?? ""),
      builder: (context, snapshot) {
        Color bgColor = snapshot.hasData ? snapshot.data! : Colors.black;
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      bottom: 0,
      left: 0,
      right: 0,
      height: player.isExpanded ? MediaQuery.of(context).size.height : 70,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy < -10) {
            setState(() => player.isExpanded = true);
          } else if (details.delta.dy > 10) {
            setState(() => player.isExpanded = false);
          }
        },
        child: player.isExpanded
            ? FullScreenPlayer(
                audioPlayer: player.audioPlayer,
                albumCover: album?.coverImageUrl ?? "",
                title: song.title,
                artist: artist?.name ?? "Unknown Artist",
                isPlaying: player.isPlaying,
                togglePlayPause: player.togglePlayPause,
                nextSong: player.nextSong,
                previousSong: player.previousSong,
                closePlayer: player.toggleExpand,
                isLiked: isLiked,
                albumCoverSize: albumCoverSize,
                downloadSong: () {},
                openQueue: () => setState(() => showQueue = !showQueue),
                toggleLike: () {
                  // implement like toggle logic
                  setState(() {
                    isLiked = !isLiked;
                    if (isLiked) {
                      SongsService().unlike(songId:song.id);
                      songsProvider.fetchLikedSongs();
                    } else {
                       SongsService().like(songId:song.id);
                      songsProvider.fetchLikedSongs();
                    }
                  });
                },
                bgColor: bgColor, // provide default background
                showQueue: showQueue,
                toggleQueue: () => setState(() => showQueue = !showQueue),
              )
            : MiniPlayer(
                audioPlayer: player.audioPlayer,
                albumCover: album?.coverImageUrl ?? "",
                title: song.title,
                artist: artist?.name ?? "Unknown Artist",
                isPlaying: player.isPlaying,
                togglePlayPause: player.togglePlayPause,
                nextSong: player.nextSong,
                previousSong: player.previousSong,
                expandPlayer: player.toggleExpand,
                isLiked: isLiked,
                toggleLike: () {
                  // implement like toggle logic
                },
              ),
      ),
  );});
  }
}
