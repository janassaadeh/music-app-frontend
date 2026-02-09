import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/models/song.dart';
import 'package:music_app/services/audio_service.dart';
import 'package:music_app/services/song_service.dart';

class PlayerProvider extends ChangeNotifier {
  final AudioPlayer audioPlayer = AudioPlayer();

  List<Song> queue = [];

  /// Start with invalid index until something is played
  int currentIndex = -1;

  bool isExpanded = false;

  /// ⭐ Safe song getter
  Song? get currentSong {
    if (!hasValidSong) return null;
    return queue[currentIndex];
  }

  bool get hasValidSong =>
      queue.isNotEmpty &&
      currentIndex >= 0 &&
      currentIndex < queue.length;

  bool get isPlaying => audioPlayer.playing;

  // ========================
  // PLAY / PAUSE
  // ========================
  void togglePlayPause() {
    if (!hasValidSong) return;

    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }

    notifyListeners();
  }

  // ========================
  // MAIN PLAY METHOD
  // ========================
  Future<void> playSong(List<Song> songs, int index) async {
    /// Guard invalid states
    if (songs.isEmpty) return;
    if (index < 0 || index >= songs.length) return;

    queue = songs;
    currentIndex = index;

    final song = queue[currentIndex];

    try {
      final previewUrl =
          await AudioController.getPreviewUrl(song.deezerTrackId);

      if (previewUrl == null) return;

      await audioPlayer.setUrl(previewUrl);
      await audioPlayer.play();

      /// Notify backend
      await SongsService().playSong(songId: song.id);
      
      notifyListeners();
    } catch (e) {
      debugPrint("PlaySong Error: $e");
    }
  }

  // ========================
  // NEXT SONG
  // ========================
  Future<void> nextSong() async {
    if (!hasValidSong) return;

    currentIndex = (currentIndex + 1) % queue.length;
      await SongsService().playSong(songId: queue[currentIndex].id);

    await _playCurrent();

  }

  // ========================
  // PREVIOUS SONG
  // ========================
  Future<void> previousSong() async {
    if (!hasValidSong) return;

    currentIndex = (currentIndex - 1 + queue.length) % queue.length;
      await SongsService().playSong(songId: queue[currentIndex].id);

    await _playCurrent();
  }

  // ========================
  // INTERNAL REPLAY HELPER
  // ========================
  Future<void> _playCurrent() async {
    if (!hasValidSong) return;

    final song = queue[currentIndex];

    try {
      final previewUrl =
          await AudioController.getPreviewUrl(song.deezerTrackId);

      if (previewUrl == null) return;

      await audioPlayer.setUrl(previewUrl);
      await audioPlayer.play();
      await SongsService().playSong(songId: song.id);

      notifyListeners();
    } catch (e) {
      debugPrint("PlayCurrent Error: $e");
    }
  }

  // ========================
  // UI EXPAND
  // ========================
  void toggleExpand() {
    isExpanded = !isExpanded;
    notifyListeners();
  }

  // ========================
  // CLEANUP
  // ========================
  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playCurrentSong() async {}
}
