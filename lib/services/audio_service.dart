import 'dart:convert';

import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class AudioController {
  final AudioPlayer player = AudioPlayer();
  static Future<String?> getPreviewUrl(String trackId) async {
    try {
      final res = await http.get(
        Uri.parse('https://api.deezer.com/track/$trackId'),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['preview'] as String?;
      } else {
        print('Deezer API returned ${res.statusCode}');
      }
    } catch (e) {
      print('Deezer error: $e');
    }

    return null;
  }

  Stream<DurationState> get durationStateStream =>
      Rx.combineLatest2<Duration, Duration?, DurationState>(
        player.positionStream,
        player.durationStream,
        (position, duration) => DurationState(
          position: position,
          total: duration ?? Duration.zero,
        ),
      );
      
        static get dio => null;

  Future<void> setSong(String url) async {
    try {
      await player.setUrl(url);
      player.play();
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  void togglePlayPause() {
    if (player.playing) {
      player.pause();
    } else {
      player.play();
    }
  }

  void dispose() {
    player.dispose();
  }
}

class DurationState {
  final Duration position;
  final Duration total;

  DurationState({required this.position, required this.total});
}
