import 'package:dio/dio.dart';

class AuthApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://192.168.1.11:8080/api',
      connectTimeout: 5000 as Duration,
      receiveTimeout: 3000 as Duration,
    ),
  );

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception("Login failed : $e");
    }
  }

  Future<Map<String, dynamic>> signUp(String email, String password) async {
    final response = await _dio.post(
      '/signUp',
      data: {
        'email': email,
        'password': password,
      },
    );
    return response.data as Map<String, dynamic>;
  }
}