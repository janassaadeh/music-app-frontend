import 'package:music_app/models/song.dart';

class Playlist {
  final String id;
  final String name;
  final String description;
  final String ownerId;
  final bool isPublic;
  final DateTime createdAt;
  final List<Song> songs;
  Playlist({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerId,
    required this.isPublic,
    required this.createdAt,
    required this.songs,

  });
factory Playlist.fromJson(Map<String, dynamic> json) {
  final songsValues =
      (json['songs']?['\$values'] as List<dynamic>?) ?? [];

  /// Build reference map
  final Map<String, dynamic> refMap = {};

  for (var item in songsValues) {
    final song = item['song'];
    if (song != null && song['\$id'] != null) {
      refMap[song['\$id']] = song;
    }
  }

  List<Song> parsedSongs = songsValues.map((e) {
    var song = e['song'];

    if (song == null) return null;

    /// Resolve $ref
    if (song.containsKey('\$ref')) {
      song = refMap[song['\$ref']];
    }

    if (song == null) return null;

    return Song.fromJson(song);
  }).whereType<Song>().toList();

  return Playlist(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    ownerId: json['ownerId'] ?? '',
    isPublic: json['isPublic'] ?? false,
    createdAt:
        DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    songs: parsedSongs,
  );
}


}
