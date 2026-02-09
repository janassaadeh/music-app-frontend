import 'package:dio/dio.dart';
import 'package:music_app/models/artist.dart';
import 'package:music_app/models/song.dart';
import 'package:music_app/models/user.dart';
import 'package:music_app/services/auth_service.dart';
import 'package:music_app/services/dio_client.dart';

class UsersService {
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

  /// GET /api/users
  /// Returns ONLY non-admin users
  Future<List<User>> getUsers() async {
    try {
      final options = await _getAuthOptions();
      final response = await _dio.get('/users', options: options);

      final List list = response.data[r'$values'];

      return list
          .map((e) => User.fromJson(e))
          .where((user) => user.isAdmin == false)
          .toList();
    } on DioException catch (e) {
      throw Exception(_error(e));
    }
  }
  Future<List<User>> getUsersFollowings() async {
    try {
      final options = await _getAuthOptions();
      final response = await _dio.get('/users/following', options: options);

      final List list = response.data[r'$values'];

      return list
          .map((e) => User.fromJson(e))
          .where((user) => user.isAdmin == false)
          .toList();
    } on DioException catch (e) {
      throw Exception(_error(e));
    }
  }
    Future<List<User>> getUsersFollowers() async {
    try {
      final options = await _getAuthOptions();
      final response = await _dio.get('/users/followers', options: options);

      final List list = response.data[r'$values'];

      return list
          .map((e) => User.fromJson(e))
          .where((user) => user.isAdmin == false)
          .toList();
    } on DioException catch (e) {
      throw Exception(_error(e));
    }
  }
  /// GET /api/users/{userId}
  /// Returns null if user is admin
  Future<User?> getUserById(String userId) async {
    try {
      final options = await _getAuthOptions();
      final response = await _dio.get('/users/$userId', options: options);

      final user = User.fromJson(response.data);

      if (user.isAdmin) {
        return null; // skip admin
      }

      return user;
    } on DioException catch (e) {
      throw Exception(_error(e));
    }
  }
  Future<List<Song>> getUserLikedSongs() async {
    try {
      final options = await _getAuthOptions();
      final response = await _dio.get('/users/liked-songs', options: options);
      final List list = response.data[r'$values'];
      return list.map((e) => Song.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(_error(e));
    }
  }
    Future<List<Song>> getUserRecentlyPlayed() async {
    try {
      final options = await _getAuthOptions();
      final response = await _dio.get('/users/recently-played', options: options);
      final List list = response.data[r'$values'];
      return list.map((e) => Song.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(_error(e));
    }
  }
  Future<List<Song>> getUserMostPlayed() async {
    try {
      final options = await _getAuthOptions();
      final response = await _dio.get('/users/most-played', options: options);
      final List list = response.data[r'$values'];
      return list.map((e) => Song.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(_error(e));
    }
  }
    Future<List<Artist>> getUserFollowedArtist() async {
    try {
      final options = await _getAuthOptions();
      final response = await _dio.get('/users/followed-artists', options: options);
      final data = response.data[r'$values'];

    if (data == null) return [];

    // Always treat as list
    final List list = data is List ? data : [data];

    return list.map((e) => Artist.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception(_error(e));
    }
  }
    Future<bool> follow({
  required String userId,
 
}) async {
  try {

          final options = await _getAuthOptions();
      final response = await _dio.post('/users/follow/$userId', options: options);
    

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
  required String userId,
 
}) async {
  try {

          final options = await _getAuthOptions();
      final response = await _dio.delete('/users/follow/$userId', options: options);
    

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
        'Users request failed';
  }
}
