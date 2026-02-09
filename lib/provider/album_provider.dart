import 'package:flutter/material.dart';
import 'package:music_app/models/album.dart';
import 'package:music_app/models/artist.dart';
import 'package:music_app/services/album_service.dart';
import 'package:music_app/services/artist_service.dart';

class AlbumProvider with ChangeNotifier {
  final AlbumService _service = AlbumService();

  List<Album> _albums = [];
  List<Album> _filtered = [];
  bool _loading = false;

  List<Album> get albums => _filtered;
  bool get loading => _loading;

  Future<void> fetchAlbums() async {
    _loading = true;
    notifyListeners();

    _albums = await _service.getAllAlbums();
    _filtered = _albums;

    _loading = false;
    notifyListeners();
  }
    Map<String, Album> get albumsMap =>
      {for (var album in _albums) album.id: album};

  void search(String query) {
    if (query.isEmpty) {
      _filtered = _albums;
    } else {
      final q = query.toLowerCase();
      _filtered = _albums.where((a) {
        return a.title.toLowerCase().contains(q);
      }).toList();
    }
    notifyListeners();
  }
}
