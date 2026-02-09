import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/pages/play_tab.dart';
import 'package:music_app/services/audio_service.dart';
import 'package:rxdart/rxdart.dart';


class MiniPlayer extends StatelessWidget {
  final AudioPlayer audioPlayer;
  final String albumCover;
  final String title;
  final String artist;
  final bool isPlaying;
  final bool isLiked;
  final VoidCallback togglePlayPause;
  final VoidCallback toggleLike;
  final VoidCallback nextSong;
  final VoidCallback previousSong;
  final VoidCallback expandPlayer;

  MiniPlayer({
    required this.audioPlayer,
    required this.albumCover,
    required this.title,
    required this.artist,
    required this.isPlaying,
    required this.isLiked,
    required this.togglePlayPause,
    required this.toggleLike,
    required this.nextSong,
    required this.previousSong,
    required this.expandPlayer,
  });

  Stream<DurationState> get _durationStateStream =>
      Rx.combineLatest2<Duration, Duration?, DurationState>(
          audioPlayer.positionStream,
          audioPlayer.durationStream,
          (position, duration) => DurationState(
              position: position, total: duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy < -10) expandPlayer();
      },
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! < 0) nextSong();
          if (details.primaryVelocity! > 0) previousSong();
        }
      },
      onTap: expandPlayer,
      child: Container(
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            StreamBuilder<DurationState>(
              stream: _durationStateStream,
              builder: (context, snapshot) {
                final durationState = snapshot.data ??
                    DurationState(position: Duration.zero, total: Duration.zero);
                return LinearProgressIndicator(
                  minHeight: 2,
                  value: durationState.total.inMilliseconds == 0
                      ? 0
                      : durationState.position.inMilliseconds /
                          durationState.total.inMilliseconds,
                  color: Colors.black,
                  backgroundColor: Colors.white24,
                );
              },
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(albumCover, width: 62, height: 62, fit: BoxFit.cover),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(artist),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border, size: 30),
                  onPressed: toggleLike,
                ),
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_arrow, size: 35),
                  onPressed: togglePlayPause,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
