import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthenticationService {
  final Dio _dio = Dio();
  final String _tokenKey = 'auth_token';

  // Login and save token
  Future<bool> authenticate(String email, String password) async {
    try {
      final response = await _dio.post(
        'https://mymusic-app-live-2.onrender.com/Auth/ApiLogin',
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data;

      String token;

      if (data is String) {
        token = data;
      } else if (data is Map && data['token'] != null) {
        token = data['token'];
      } else if (data is Map && data['data'] != null) {
        token = data['data']['token'];
      } else {
        throw Exception('Unexpected login response');
      }

      await _saveToken(token);
      return true;
    } catch (e) {
      print('Error during authentication: $e');
      rethrow;
    }
  }
Future<bool> register({
  required String email,
  required String password,
  required String firstName,
  required String lastName,
  required DateTime dateOfBirth,
  required String gender,
}) async {
  try {
    final response = await _dio.post(
      'https://mymusic-app-live-2.onrender.com/Auth/ApiRegister',
      data: {
        "Email": email,
        "Password": password,
        "FirstName": firstName,
        "LastName": lastName,
        "DateOfBirth": dateOfBirth.toIso8601String(),
        "Gender": gender,
      },
    );

    /// Check if success
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }

    return false;
  } on DioException catch (e) {
    print("Register error: ${e.response?.data ?? e.message}");
    return false;
  } catch (e) {
    print("Unexpected error: $e");
    return false;
  }
}


  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(_tokenKey);
    if (token != null) {
      return !JwtDecoder.isExpired(token);
    }
    return false;
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  /// ✅ NEW: Get currently logged-in user from JWT
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final token = await getToken();
    if (token == null || JwtDecoder.isExpired(token)) return null;

    final Map<String, dynamic> payload = JwtDecoder.decode(token);

    // Optional: skip admin users
    if (payload['role'] == 'Admin') return null;

    return {
      'id': payload['sub'],       // user ID
      'email': payload['email'],  // user email
      'role': payload['role'],    // user role
    };
  }
}
