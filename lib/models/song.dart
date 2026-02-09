class Song {
  final String id;
  final String title;
  final String deezerTrackId;
  final Duration duration;
  final String artistId;
  final String? albumId;
   bool? isLiked;

  Song({
    required this.id,
    required this.title,
    required this.deezerTrackId,
    required this.duration,
    required this.artistId,
    this.albumId,
     this.isLiked,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id']??'',
      title: json['title']??'',
      deezerTrackId: json['deezerTrackId']??'',
      duration: _parseDuration(json['duration']??'00:00:00'),
      artistId: json['artistId']??'',
      albumId: json['albumId']??''
    );
  }

  static Duration _parseDuration(String value) {
    final parts = value.split(':');
    return Duration(
      hours: int.parse(parts[0]),
      minutes: int.parse(parts[1]),
      seconds: int.parse(parts[2]),
    );
  }
}
