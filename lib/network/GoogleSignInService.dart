import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> loginWithGoogle() async {
    final dio = Dio();
    try {
      GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        GoogleSignInAuthentication auth = await account.authentication;
        String? idToken = auth.idToken;

        if (idToken != null) {
          Response response = await dio.post(
            '/auth/login/google',
            data: {
              'googleToken': idToken,
            },
          );
          print('Login success: ${response.data}');
        }
      }
    } catch (e) {
      print('Google sign-in error: $e');
    }
  }
}
