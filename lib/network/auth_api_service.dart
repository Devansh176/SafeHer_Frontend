import 'package:dio/dio.dart';

class AuthApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.11:8080/api/auth',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 3),
      followRedirects: false,
      validateStatus: (status) => status! < 500,
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
    } on DioException catch (dioError) {
      throw Exception(_handleDioError(dioError, 'SignUp'));
    } catch (e) {
      throw Exception("SignUp failed: $e");
    }
  }

  String _handleDioError(DioError dioError, String action) {
    String errorDescription = "";
    switch (dioError.type) {
      case DioExceptionType.cancel:
        errorDescription = "$action request was cancelled.";
        break;
      case DioExceptionType.connectionTimeout:
        errorDescription = "$action connection timeout.";
        break;
      case DioExceptionType.receiveTimeout:
        errorDescription = "$action receive timeout.";
        break;
      case DioExceptionType.sendTimeout:
        errorDescription = "$action send timeout.";
        break;
      case DioExceptionType.badResponse:
        if (dioError.response != null) {
          if (dioError.response!.statusCode == 302) {
            errorDescription =
            "$action encountered a redirect (302). Check if the endpoint URL is correct.";
          } else {
            errorDescription =
            "$action failed with status code ${dioError.response!.statusCode}: ${dioError.response!.statusMessage}";
          }
        } else {
          errorDescription = "$action failed due to an unknown response error.";
        }
        break;
      case DioExceptionType.unknown:
        errorDescription = "$action failed due to a network error: ${dioError.message}";
        break;
      case DioExceptionType.badCertificate:
        throw UnimplementedError();
      case DioExceptionType.connectionError:
        throw UnimplementedError();
    }
    return errorDescription;
  }
}
