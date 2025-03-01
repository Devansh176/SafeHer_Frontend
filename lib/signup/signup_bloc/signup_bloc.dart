import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import '../signup_auth/email_auth_signup.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final EmailAuthentication emailAuth;

  SignupBloc(this.emailAuth) : super(SignupInitial()) {
    on<SignUpButtonPressed>(_signUpButtonPressed);
  }

  FutureOr<void> _signUpButtonPressed(event, Emitter<SignupState> emit) async {
    emit(SignupLoading());
    try{
      final userCredential = await emailAuth.signUp(event.email, event.password);
      if(userCredential != null){
        await userCredential.user?.sendEmailVerification();
        emit(SignupSuccess());
      } else {
        emit(SignupFailure(errorMsg: 'Signup failed. Please try again.'));
      }
    } on FirebaseAuthException catch (e) {
      emit(SignupFailure(errorMsg: e.toString()));
    }
  }
}
