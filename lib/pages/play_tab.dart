import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../widgets/mini_player.dart';
import '../widgets/full_player.dart';
import '../widgets/queue_sheet.dart';
import '../utils/color_pick.dart';

class PlayTab extends StatefulWidget {
  const PlayTab({Key? key}) : super(key: key);

  @override
  State<PlayTab> createState() => _PlayTabState();
}

class _PlayTabState extends State<PlayTab> with SingleTickerProviderStateMixin {
  final List<Map<String, String>> songs = [
    {
      "album_cover": "https://cdn-images.dzcdn.net/images/artist/be0a7c550567f4af0ed202d7235b74d6/250x250-000000-80-0-0.jpg",
      "title": "Song One",
      "artist": "Artist One",
      "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"
    },
    {
      "album_cover": "https://cdn-images.dzcdn.net/images/cover/cae2245174d0f56b69e81cfb39f14b6e/250x250-000000-80-0-0.jpg",
      "title": "Song Two",
      "artist": "Artist Two",
      "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3"
    },
    {
      "album_cover": "https://cdn-images.dzcdn.net/images/cover/cae2245174d0f56b69e81cfb39f14b6e/250x250-000000-80-0-0.jpg",
      "title": "Song Three",
      "artist": "Artist Three",
      "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3"
    },
  ];

  late AudioPlayer _audioPlayer;
  late PageController _pageController;

  int currentIndex = 0;
  bool isPlayerExpanded = false;
  bool isPlaying = false;
  bool isLiked = false;
  double albumCoverSize = 350.0;
  bool showQueue = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _pageController = PageController(initialPage: currentIndex);
    _playCurrentSong();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _playCurrentSong() async {
    try {
      await _audioPlayer.setUrl(songs[currentIndex]["url"]!);
      _audioPlayer.play();
      setState(() => isPlaying = true);
    } catch (e) {
      debugPrint("Error loading audio: $e");
    }
  }

  void playSong(int index) {
    setState(() {
      currentIndex = index;
      isPlayerExpanded = false;
      isPlaying = true;
      isLiked = false;
      albumCoverSize = 350.0;
    });
    _pageController.jumpToPage(currentIndex);
    _playCurrentSong();
  }

  void nextSong() {
    setState(() {
      currentIndex = (currentIndex + 1) % songs.length;
      isPlaying = true;
      isLiked = false;
      albumCoverSize = 350.0;
    });
    _pageController.jumpToPage(currentIndex);
    _playCurrentSong();
  }

  void previousSong() {
    setState(() {
      currentIndex = (currentIndex - 1 + songs.length) % songs.length;
      isPlaying = true;
      isLiked = false;
      albumCoverSize = 350.0;
    });
    _pageController.jumpToPage(currentIndex);
    _playCurrentSong();
  }

  void togglePlayPause() {
    if (_audioPlayer.playing) {
      _audioPlayer.pause();
      setState(() {
        isPlaying = false;
        albumCoverSize = 330.0;
      });
    } else {
      _audioPlayer.play();
      setState(() {
        isPlaying = true;
        albumCoverSize = 350.0;
      });
    }
  }

  void toggleLike() => setState(() => isLiked = !isLiked);
  void downloadSong() {}

  void openQueue() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => QueueSheet(
        songs: songs,
        currentIndex: currentIndex,
        playSong: playSong,
        updateQueue: (newSongs) => setState(() {
          songs.clear();
          songs.addAll(newSongs);
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = songs[currentIndex];
    final currentTitle = currentSong["title"]!;
    final currentArtist = currentSong["artist"]!;
    final currentAlbum = currentSong["album_cover"]!;

    return FutureBuilder<Color>(
      future: getColorFromImageUrl(currentAlbum),
      builder: (context, snapshot) {
        Color bgColor = snapshot.hasData ? snapshot.data! : Colors.black;

        return Stack(
          children: [
            // ---------------- SONG LIST ----------------
            ListView.builder(
              padding: const EdgeInsets.only(bottom: 120),
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return ListTile(
                  leading: Image.network(song["album_cover"]!),
                  title: Text(song["title"]!, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(song["artist"]!),
                  trailing: const Icon(Icons.play_arrow),
                  onTap: () => playSong(index),
                );
              },
            ),

            // ---------------- ANIMATED PLAYER ----------------
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              bottom: 0,
              left: 0,
              right: 0,
              height: isPlayerExpanded ? MediaQuery.of(context).size.height : 70,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy < -10) setState(() => isPlayerExpanded = true);
                  if (details.delta.dy > 10) setState(() => isPlayerExpanded = false);
                },
                child: Container(
                  color: isPlayerExpanded ? bgColor : Colors.transparent,
                  child: isPlayerExpanded
                      ? FullScreenPlayer(
                          audioPlayer: _audioPlayer,
                          albumCover: currentAlbum,
                          title: currentTitle,
                          artist: currentArtist,
                          isPlaying: isPlaying,
                          isLiked: isLiked,
                          albumCoverSize: albumCoverSize,
                          togglePlayPause: togglePlayPause,
                          toggleLike: toggleLike,
                          nextSong: nextSong,
                          previousSong: previousSong,
                          downloadSong: downloadSong,
                          closePlayer: () => setState(() => isPlayerExpanded = false),
                          openQueue: openQueue,
                          bgColor: bgColor,
                            showQueue: showQueue,
                        toggleQueue: () => setState(() => showQueue = !showQueue),
                        )
                      : MiniPlayer(
                          audioPlayer: _audioPlayer,
                          albumCover: currentAlbum,
                          title: currentTitle,
                          artist: currentArtist,
                          isPlaying: isPlaying,
                          isLiked: isLiked,
                          togglePlayPause: togglePlayPause,
                          toggleLike: toggleLike,
                          nextSong: nextSong,
                          previousSong: previousSong,
                          expandPlayer: () => setState(() => isPlayerExpanded = true),
                        ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
