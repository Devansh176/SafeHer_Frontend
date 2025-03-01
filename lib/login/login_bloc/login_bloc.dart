import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final EmailAuthentication emailAuth;

  LoginBloc({required this.emailAuth}) : super(LoginInitial()) {
    on<LoginButtonPressed>(_loginButtonPressed);
  }

  FutureOr<void> _loginButtonPressed(LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      await emailAuth.signIn(
          event.email,
          event.password
      );
      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(errorMsg: e.message ?? "Login Failed"));
    } catch (e) {
      emit(LoginFailure(errorMsg: e.toString()));
    }
  }
}
