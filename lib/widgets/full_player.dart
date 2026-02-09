import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/pages/play_tab.dart';
import 'package:music_app/services/audio_service.dart';
import 'package:music_app/widgets/album_cover.dart';
import 'package:music_app/widgets/queue.dart';
import 'package:rxdart/rxdart.dart';
import 'mini_player.dart';

class FullScreenPlayer extends StatelessWidget {
  final AudioPlayer audioPlayer;
  final String albumCover;
  final String title;
  final String artist;
  final bool isPlaying;
  final bool isLiked;
  final double albumCoverSize;
  final VoidCallback togglePlayPause;
  final VoidCallback toggleLike;
  final VoidCallback nextSong;
  final VoidCallback previousSong;
  final VoidCallback downloadSong;
  final VoidCallback closePlayer;
  final VoidCallback openQueue;
  final Color bgColor;
  final bool showQueue;
  final VoidCallback toggleQueue;

  const FullScreenPlayer({
    super.key,
    required this.audioPlayer,
    required this.albumCover,
    required this.title,
    required this.artist,
    required this.isPlaying,
    required this.isLiked,
    required this.albumCoverSize,
    required this.togglePlayPause,
    required this.toggleLike,
    required this.nextSong,
    required this.previousSong,
    required this.downloadSong,
    required this.closePlayer,
    required this.openQueue,
    required this.bgColor,
    required this.showQueue ,
    required this.toggleQueue,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 10) closePlayer();
        },
        child: Container(
          color: bgColor,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              // 🔽 CLOSE BUTTON
              Padding(
                padding: const EdgeInsets.only(left: 12,top:100),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.black26,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                      onPressed: closePlayer,
                    ),
                  ),
                ),
              ),

              // 🎵 ALBUM ART
                Expanded(
                  flex: 5,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: showQueue
                        ? QueueView(
                          )
                        : AlbumCover(
                            albumCover: albumCover,
                            albumCoverSize: albumCoverSize,
                          ),
                  ),
                ),


              // 🎶 SONG INFO + PROGRESS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900)),
                    const SizedBox(height: 6),
                    Text(artist,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 12),

                    StreamBuilder<DurationState>(
                      stream: Rx.combineLatest2(
                        audioPlayer.positionStream,
                        audioPlayer.durationStream,
                        (Duration p, Duration? d) =>
                            DurationState(position: p, total: d ?? Duration.zero),
                      ),
                      builder: (context, snapshot) {
                        final state = snapshot.data ??
                            DurationState(position: Duration.zero, total: Duration.zero);

                        return LinearProgressIndicator(
                          value: state.total.inMilliseconds == 0
                              ? 0
                              : state.position.inMilliseconds /
                                  state.total.inMilliseconds,
                          minHeight: 6,
                          backgroundColor: Colors.white24,
                          color: Colors.white,
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // ⏯ CONTROLS
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: toggleLike,
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_previous_rounded,
                        color: Colors.white, size: 48),
                    onPressed: previousSong,
                  ),
                  IconButton(
                    icon: Icon(
                      isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      color: Colors.white,
                      size: 70,
                    ),
                    onPressed: togglePlayPause,
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next_rounded,
                        color: Colors.white, size: 48),
                    onPressed: nextSong,
                  ),
                  IconButton(
                    icon: const Icon(Icons.cloud_download_outlined,
                        color: Colors.white, size: 28),
                    onPressed: downloadSong,
                  ),
                ],
              ),

              // 📃 QUEUE
              Padding(
                padding: const EdgeInsets.only(bottom: 40,top:20),
                child: GestureDetector(
                  onTap: toggleQueue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.queue_music, color: Colors.white),
                      SizedBox(width: 6),
                      Text("Queue",
                          style:
                              TextStyle(color: Colors.white, fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
