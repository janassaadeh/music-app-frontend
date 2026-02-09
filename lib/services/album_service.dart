import 'package:dio/dio.dart';
import 'package:music_app/models/album.dart';
import 'package:music_app/models/artist.dart';
import 'package:music_app/models/song.dart';
import 'package:music_app/services/auth_service.dart';
import 'package:music_app/services/dio_client.dart';

class AlbumService {
  final Dio _dio = DioClient.dio;
  final AuthenticationService _authService = AuthenticationService();

  /// Helper to get headers with bearer token
  Future<Options> _getAuthOptions() async {
    final token = await _authService.getToken(); // your method to get token
    return Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  /// GET /artist
  Future<List<Album>> getAllAlbums() async {
  try {
    final options = await _getAuthOptions();
      final response = await _dio.get('/albums', options: options);

    final data = response.data[r'$values'];

    if (data == null) return [];

    // Always treat as list
    final List list = data is List ? data : [data];

    return list.map((e) => Album.fromJson(e)).toList();
  } on DioException catch (e) {
    throw Exception(_error(e));
  }
}


  String _error(DioException e) {
    return e.response?.data?['message'] ??
        e.message ??
        'Unexpected error occurred';
  }
}
