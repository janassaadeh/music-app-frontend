import 'package:flutter/material.dart';
import 'package:music_app/models/genre.dart';
import 'package:music_app/models/song.dart';
import 'package:music_app/models/artist.dart';
import 'package:music_app/models/album.dart';
import 'package:music_app/services/song_service.dart';
import 'package:music_app/services/user_service.dart';

class SongsProvider with ChangeNotifier {
  final SongsService _songsService = SongsService();
  final UsersService _usersService = UsersService();

  List<Song> _songs = [];
  List<Song> _likedSongs = [];
  List<Song> _recentlyPlayedSongs = [];
  List<Song> _mostPlayedSongs = [];

  List<Song> _filtered = [];
  bool _loading = false;

  // Maps for fast lookup
  Map<String, Artist> artistMap = {};
  Map<String, Album> albumMap = {};

  List<Song> get songs => _filtered;
  List<Song> get likedSongs => _likedSongs;
  List<Song> get mostPlayedSongs => _mostPlayedSongs;
  List<Song> get recentlyPlayedSongs => _recentlyPlayedSongs;

  bool get loading => _loading;
Map<String, Song> get songsMap =>
      {for (var song in _songs) song.id: song};
  /// fetch songs and optionally maps
  Future<void> fetchSongs({Map<String, Artist>? artists, Map<String, Album>? albums}) async {
    _loading = true;
    notifyListeners();

    _songs = await _songsService.getAllSongs();
    _filtered = _songs;

    if (artists != null) artistMap = artists;
    if (albums != null) albumMap = albums;

    _loading = false;
    notifyListeners();
  }
  /// Sets isLiked = true for songs that are in _likedSongs
void applyLikedFlags() {
  final likedIds = _likedSongs.map((s) => s.id).toSet();

  for (var song in _songs) {
    song.isLiked = likedIds.contains(song.id);
  }

  _filtered = _songs;
  notifyListeners();
}

  Future<void> fetchLikedSongs({Map<String, Artist>? artists, Map<String, Album>? albums}) async {
    _loading = true;
    notifyListeners();

    _likedSongs = await _usersService.getUserLikedSongs();
    if (artists != null) artistMap = artists;
    if (albums != null) albumMap = albums;


    _loading = false;
    notifyListeners();
  }
  Future<void> fetchRecentlyPlayedSongs({Map<String, Artist>? artists, Map<String, Album>? albums}) async {
    _loading = true;
    notifyListeners();

    _recentlyPlayedSongs = await _usersService.getUserRecentlyPlayed();
    if (artists != null) artistMap = artists;
    if (albums != null) albumMap = albums;

    _loading = false;
    notifyListeners();
  }
    Future<void> fetchMostPlayedSongs({Map<String, Artist>? artists, Map<String, Album>? albums}) async {
    _loading = true;
    notifyListeners();

    _mostPlayedSongs = await _usersService.getUserMostPlayed();
    if (artists != null) artistMap = artists;
    if (albums != null) albumMap = albums;

    _loading = false;
    notifyListeners();
  }
List<Song> getSongsByArtist(Artist artist) {
  final albumIds = artist.albums.map((a) => a.id).toSet();

  return _songs
      .where((song) => albumIds.contains(song.albumId))
      .toList();
}
// 1️⃣ Get all unique genres from your artistMap
List<Genre> get allGenres {
  final Map<String, Genre> uniqueGenres = {};

  for (final artist in artistMap.values) {
    for (final genre in artist.genres) {
      uniqueGenres[genre.id] = genre; // deduplicate by id
    }
  }

  return uniqueGenres.values.toList();
}

// 2️⃣ Get all songs that belong to a specific genre
List<Song> getSongsByGenre(String genreId) {
  // Find all artist IDs that have this genre
  final artistIds = artistMap.values
      .where((artist) => artist.genres.any((g) => g.id == genreId))
      .map((artist) => artist.id)
      .toSet();

  // Return all songs whose artist belongs to that genre
  return _songs.where((song) => artistIds.contains(song.artistId)).toList();
}



  /// Search by title, artist name, or album name
  void search(String query) {
    if (query.isEmpty) {
      _filtered = _songs;
    } else {
      final q = query.toLowerCase();
      _filtered = _songs.where((s) {
        final artistName = artistMap[s.artistId]?.name.toLowerCase() ?? '';
        final albumName = albumMap[s.albumId]?.title.toLowerCase() ?? '';
        return s.title.toLowerCase().contains(q) ||
               artistName.contains(q) ||
               albumName.contains(q);
      }).toList();
    }
    notifyListeners();
  }
}
