import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safer/home/home_ui/homePage.dart';
import 'package:safer/signup/signup_bloc/signup_bloc.dart';

import '../signup_auth/email_auth_signup.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
        create: (context) => SignupBloc(EmailAuthentication()),
        child: BlocConsumer<SignupBloc, SignupState>(
          listener: (context, state) {
            if (state is SignupSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            } else if (state is SignupFailure) {
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
                    "Create your account here",
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
                              context.read<SignupBloc>().add(
                                SignUpButtonPressed(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                ),
                              );
                            }
                          },
                          child: state is SignupLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                            'SignUp',
                            style: GoogleFonts.preahvihear(
                              color: Colors.green[900],
                              fontSize: fontSize * 0.75,
                              fontWeight: FontWeight.w900,
                            ),
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