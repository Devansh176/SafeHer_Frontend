import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../home/home_ui/homePage.dart';

class GoogleSignInService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  Future<void> loginWithGoogle(BuildContext context) async {
    try {
      isLoading.value = true;
      GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        final GoogleSignInAuthentication auth = await account.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: auth.accessToken,
            idToken: auth.idToken
        );

        UserCredential userCredential = await _firebaseAuth
            .signInWithCredential(credential);
        User? user = userCredential.user;
        if (user != null) {
          isLoading.value = false;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Signed in as ${user.displayName}')),
          );
        }
      } else {
        isLoading.value = false;
        print('Google Sign-In canceled');
        return;
      }
    } catch (e) {
      isLoading.value = false;
      print('Error logging in with Google: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      print('Logged out');
    } catch (e) {}
  }
}