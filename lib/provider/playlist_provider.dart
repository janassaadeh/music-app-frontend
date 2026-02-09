import 'package:flutter/material.dart';
import 'package:music_app/models/playlist.dart';
import 'package:music_app/services/playlist_service.dart';

class PlaylistProvider with ChangeNotifier {
  final PlaylistService _service = PlaylistService();

  List<Playlist> _playlists = [];
  bool _loading = false;

  List<Playlist> get playlist => _playlists;
  bool get loading => _loading;

  Future<void> fetchPlaylists() async {
    _loading = true;
    notifyListeners();

    _playlists = await _service.getPlaylists();

    _loading = false;
    notifyListeners();
  }
   
}
