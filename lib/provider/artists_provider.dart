import 'package:flutter/material.dart';
import 'package:music_app/models/artist.dart';
import 'package:music_app/services/artist_service.dart';
import 'package:music_app/services/user_service.dart';

class ArtistsProvider with ChangeNotifier {
  final ArtistsService _service = ArtistsService();
  final UsersService _usersService = UsersService();

  List<Artist> _artists = [];
  List<Artist> _filtered = [];
  List<Artist> _followedArtists = [];
  bool _loading = false;

  List<Artist> get artists => _filtered;
  List<Artist> get followedArtists => _followedArtists;

  bool get loading => _loading;

  Future<void> fetchArtists() async {
    _loading = true;
    notifyListeners();

    _artists = await _service.getAllArtists();
    _filtered = _artists;

    _loading = false;
    notifyListeners();
  }
    Future<void> fetchFollowedArtist() async {
    _loading = true;
    notifyListeners();

    _followedArtists = await _usersService.getUserFollowedArtist();


    _loading = false;
    notifyListeners();
  }
  List<Artist> getSimilarArtists(Artist artist) {
  final genreIds = artist.genres.map((g) => g.id).toSet();

  return _artists
      .where((a) =>
          a.id != artist.id &&
          a.genres.any((g) => genreIds.contains(g.id)))
      .take(5)
      .toList();
}

Map<String, Artist> get artistsMap =>
      {for (var artist in _artists) artist.id: artist};
  void search(String query) {
    if (query.isEmpty) {
      _filtered = _artists;
    } else {
      final q = query.toLowerCase();
      _filtered = _artists.where((a) {
        return a.name.toLowerCase().contains(q);
      }).toList();
    }
    notifyListeners();
  }
}
