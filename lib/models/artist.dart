import 'package:music_app/models/album.dart';
import 'package:music_app/models/genre.dart';

class Artist {
  final String id;
  final String name;
  final String imageUrl;
  final List<Album> albums;
  final List<Genre> genres;

  Artist({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.albums,
    required this.genres,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    final albumsJson = json['albums']?[r'$values'] ?? [];
    final genresJson = json['genres']?[r'$values'] ?? [];

    return Artist(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'] ?? '',
      albums: albumsJson.map<Album>((a) => Album.fromJson(a)).toList(),
      genres: genresJson.map<Genre>((g) => Genre.fromJson(g)).toList(),
    );
  }
}
