import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/playlist.dart';
import 'package:music_app/services/auth_service.dart';
import 'dio_client.dart';

class PlaylistService {
  final Dio _dio = DioClient.dio;
  final AuthenticationService _authService = AuthenticationService();

  /// Returns Dio options with the current auth token
  Future<Options> _getAuthOptions() async {
    final token = await _authService.getToken();
    return Options(
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  /// GET all playlists
  Future<List<Playlist>> getPlaylists() async {
    try {
      final options = await _getAuthOptions();
      final response = await _dio.get('/playlists', options: options);

      // Backend uses $values array
      final List data = response.data['\$values'] ?? [];
      print(data);
      return data.map((json) => Playlist.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch playlists: $e');
    }
  }

  /// CREATE a new playlist
  Future<Playlist?> createPlaylist({
    required String name,
    required String description,
  }) async {
    try {
      final options = await _getAuthOptions();
      final response = await _dio.post(
        '/playlists',
        data: {
          "Name": name,
          "Description": description,
        },
        options: options,
      );

      if (response.data != null) {
        return Playlist.fromJson(response.data);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to create playlist: $e');
    }
  }

  /// ADD a song to a playlist
  Future<void> addSongToPlaylist({
    required String playlistId,
    required String songId,
    required int position,
  }) async {
    try {
      final options = await _getAuthOptions();
      await _dio.post(
        '/playlists/$playlistId/songs',
        queryParameters: {
          "songId": songId,
          "position": position,
        },
        options: options,
      );
    } on DioException catch (e) {
      // Duplicate song protection
      if (e.response?.statusCode == 500 &&
          e.response!.data.toString().contains("duplicate")) {
        debugPrint("Song already exists in playlist");
        return;
      }
      rethrow;
    }
  }
}
