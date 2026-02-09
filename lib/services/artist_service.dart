import 'package:dio/dio.dart';
import 'package:music_app/models/album.dart';
import 'package:music_app/models/artist.dart';
import 'package:music_app/models/song.dart';
import 'package:music_app/services/auth_service.dart';
import 'package:music_app/services/dio_client.dart';

class ArtistsService {
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
  Future<List<Artist>> getAllArtists() async {
  try {
    final options = await _getAuthOptions();
    final response = await _dio.get('/artist', options: options);
  
    final data = response.data[r'$values'];

    if (data == null) return [];

    // Always treat as list
    final List list = data is List ? data : [data];

    return list.map((e) => Artist.fromJson(e)).toList();
  } on DioException catch (e) {
    throw Exception(_error(e));
  }
}


  /// GET /artist/{artistId}
  Future<Artist> getArtistById(String artistId) async {
    try {
      final options = await _getAuthOptions();
      final response = await _dio.get('/artist/$artistId', options: options);
      return Artist.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_error(e));
    }
  }

  /// GET /artist/{artistId}/similar
  Future<List<Artist>> getSimilarArtists(String artistId) async {
    try {
      final options = await _getAuthOptions();
      final response =
          await _dio.get('/artist/$artistId/similar', options: options);

      final List list = response.data[r'$values'];
      return list.map((e) => Artist.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(_error(e));
    }
  }

  /// GET /artist/{artistId}/albums
  Future<List<Album>> getArtistAlbums(String artistId) async {
    try {
      final options = await _getAuthOptions();
      final response =
          await _dio.get('/artist/$artistId/albums', options: options);

      final List list = response.data[r'$values'];
      return list.map((e) => Album.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(_error(e));
    }
  }

  /// GET /artist/{artistId}/topsongs
  Future<List<Song>> getArtistTopSongs(String artistId) async {
    try {
      final options = await _getAuthOptions();
      final response =
          await _dio.get('/artist/$artistId/topsongs', options: options);

      final List list = response.data[r'$values'];
      return list.map((e) => Song.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(_error(e));
    }
  }
    Future<bool> follow({
  required String artistId,
 
}) async {
  try {

          final options = await _getAuthOptions();
      final response = await _dio.post('/users/follow-artist/$artistId', options: options);
    

    /// Check if success
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }

    return false;
  } on DioException catch (e) {
    print("Follow error: ${e.response?.data ?? e.message}");
    return false;
  } catch (e) {
    print("Unexpected error: $e");
    return false;
  }
}
  Future<bool> unfollow({
  required String artistId,
 
}) async {
  try {

          final options = await _getAuthOptions();
      final response = await _dio.delete('/users/follow-artist/$artistId', options: options);
    

    /// Check if success
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }

    return false;
  } on DioException catch (e) {
    print("Follow error: ${e.response?.data ?? e.message}");
    return false;
  } catch (e) {
    print("Unexpected error: $e");
    return false;
  }
}
  String _error(DioException e) {
    return e.response?.data?['message'] ??
        e.message ??
        'Unexpected error occurred';
  }
}
