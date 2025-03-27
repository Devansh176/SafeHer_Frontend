import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safer/home/home_ui/home_bloc/contacts/contacts_bloc.dart';
import 'package:safer/repositories/contacts_repository.dart';
import 'firebase_options.dart';
import 'home/home_ui/homePage.dart';
import 'login/login_ui/loginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactsBloc(ContactsRepository()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthCheck(),
      ),
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          } else if (snapshot.hasData) {
            return HomePage();
          } else if (snapshot.hasError) {
            return Center(child: Text('Something went wrong!'),);
          } else {
            return LoginPage();
          }
        }
    );
  }
}

