class Album {
  final String id;
  final String title;
  final String coverImageUrl;
  final DateTime releaseDate;

  Album({
    required this.id,
    required this.title,
    required this.coverImageUrl,
    required this.releaseDate,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      title: json['title'],
      coverImageUrl: json['coverImageUrl'] ?? '',
      releaseDate: DateTime.parse(json['releaseDate']),
    );
  }
}
