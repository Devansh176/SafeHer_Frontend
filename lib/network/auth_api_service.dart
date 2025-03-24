import 'package:dio/dio.dart';

class AuthApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.11:8080/api/auth',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 3),
      followRedirects: false,
    ),
  )..options.headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };


  Future<void> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      final data = response.data as Map<String, dynamic>;
      if (data['success'] == true) {
        print("Login successful: ${data['token']}");
      } else {
        print("Login failed: ${data['message']}");
      }
    } catch (e) {
      print("Error logging in: $e");
    }
  }


  Future<Map<String, dynamic>> signUp(String email, String password) async {
    try {
      final response = await _dio.post(
        '/signUp',
        data: {
          'email': email,
          'password': password,
        },
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception("SignUp failed: $e");
    }
  }
}
