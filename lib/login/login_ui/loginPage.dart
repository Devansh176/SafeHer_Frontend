import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safer/network/auth_api_service.dart';

import '../../home/home_ui/homePage.dart';
import '../../network/GoogleSignInService.dart';
import '../login_bloc/login_bloc.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double height = screenSize.height;
    final double fontSize = width * 0.05;
    final double padding = width * 0.05;

    return Scaffold(
      backgroundColor: Colors.lightGreen[50],
      body: BlocProvider(
        create: (context) => LoginBloc(authApi: AuthApiService()),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("❌ ${state.errorMsg}")),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(padding * 0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: height * 0.2,),
                  Text(
                    "Login here",
                    style: GoogleFonts.preahvihear(
                      fontSize: fontSize * 1.5,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: height * 0.05,),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        _buildInputField("Email", _emailController),
                        _buildPasswordField("Password", _passwordController),
                        SizedBox(height: height * 0.03,),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<LoginBloc>().add(
                                LoginButtonPressed(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                ),
                              );
                            }
                          },
                          child: state is LoginLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                            'Login',
                            style: GoogleFonts.preahvihear(
                              color: Colors.green[900],
                              fontSize: fontSize * 0.75,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.01,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: GoogleFonts.preahvihear(
                                color: Colors.green[800],
                                fontSize: fontSize * 0.75,
                              ),
                            ),
                            TextButton(
                              onPressed: () {

                              },
                              child: Text(
                                "Sign Up",
                                style: GoogleFonts.preahvihear(
                                  color: Colors.green[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: fontSize * 0.75,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.03,),
                        Center(
                          child: Text('or'),
                        ),
                        SizedBox(height: height * 0.03,),
                        Center(
                          child: ValueListenableBuilder(
                            valueListenable: isLoading,
                            builder: (context, loading, child) {
                              return loading ? CircularProgressIndicator() :
                              SignInButton(
                                Buttons.Google,
                                text: "Sign in with Google",
                                onPressed: () async {
                                  isLoading.value = true;
                                  await GoogleSignInService().loginWithGoogle(context);
                                  isLoading.value = false;
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputField(String labelText, TextEditingController controller) {
    final screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double padding = width * 0.05;

    return Padding(
      padding: EdgeInsets.only(left: padding * 0.8, right: padding * 0.8,),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.lightGreen[800],
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green[700]!,
            ),
            borderRadius: BorderRadius.circular(30,),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green[700]!,
            ),
            borderRadius: BorderRadius.circular(30,),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$labelText is required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField(String labelText, TextEditingController controller) {
    final screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double padding = width * 0.05;

    return Padding(
      padding: EdgeInsets.only(top: padding * 0.8, left: padding * 0.8, right: padding * 0.8,),
      child: TextFormField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.lightGreen[800],
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green[700]!,
            ),
            borderRadius: BorderRadius.circular(30,),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green[700]!,
            ),
            borderRadius: BorderRadius.circular(30,),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$labelText is required';
          }
          return null;
        },
      ),
    );
  }
}
