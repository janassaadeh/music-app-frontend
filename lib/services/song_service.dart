import 'package:dio/dio.dart';
import 'package:music_app/models/song.dart';
import 'package:music_app/services/auth_service.dart';
import 'package:music_app/services/dio_client.dart';

class SongsService {
  final Dio _dio = DioClient.dio;
  final AuthenticationService _authService = AuthenticationService();

  /// Helper to get headers with bearer token
  Future<Options> _getAuthOptions() async {
    final token = await _authService.getToken(); // fetch your current token
    return Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  /// GET /songs
  Future<List<Song>> getAllSongs() async {
    try {
      final options = await _getAuthOptions();
      final response = await _dio.get('/songs', options: options);

      final List list = response.data[r'$values'];
      print(list);
      return list.map((e) => Song.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(_error(e));
    }
  }

  /// GET /songs/{songId}
  Future<Song> getSongById(String songId) async {
    try {
      final options = await _getAuthOptions();
      final response = await _dio.get('/songs/$songId', options: options);
      return Song.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_error(e));
    }
  }
 Future<List<Song>> getArtistTopSongs(String artistId) async {
    try {
      final options = await _getAuthOptions();
      final response = await _dio.get('/artist/$artistId/topsongs', options: options);
      final List list = response.data[r'$values'];
      return list.map((e) => Song.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(_error(e));
    }
  }
  /// GET /songs/top-by-genre?genreId={genreId}
  Future<List<Song>> getTopSongsByGenre(String genreId) async {
    try {
      final options = await _getAuthOptions();
      final response = await _dio.get(
        '/songs/top-by-genre',
        queryParameters: {'genreId': genreId},
        options: options,
      );

      final List list = response.data[r'$values'];
      return list.map((e) => Song.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(_error(e));
    }
  }
  Future<bool> like({
  required String songId,
 
}) async {
  try {

          final options = await _getAuthOptions();
      final response = await _dio.post('/users/like/$songId', options: options);
    

    /// Check if success
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }

    return false;
  } on DioException catch (e) {
    print("Like error: ${e.response?.data ?? e.message}");
    return false;
  } catch (e) {
    print("Unexpected error: $e");
    return false;
  }
}
  Future<bool> unlike({
  required String songId,
 
}) async {
  try {

          final options = await _getAuthOptions();
      final response = await _dio.post('/users/like/$songId', options: options);
    

    /// Check if success
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }

    return false;
  } on DioException catch (e) {
    print("Like error: ${e.response?.data ?? e.message}");
    return false;
  } catch (e) {
    print("Unexpected error: $e");
    return false;
  }
}
 Future<bool> playSong({
  required String songId,
 
}) async {
  try {

          final options = await _getAuthOptions();
      final response = await _dio.post('/users/play/$songId', options: options);
    

    /// Check if success
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }

    return false;
  } on DioException catch (e) {
    print("Like error: ${e.response?.data ?? e.message}");
    return false;
  } catch (e) {
    print("Unexpected error: $e");
    return false;
  }
}
  String _error(DioException e) {
    return e.response?.data?['message'] ??
        e.message ??
        'Songs request failed';
  }
}
