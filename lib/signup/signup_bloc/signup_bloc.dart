import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:safer/network/auth_api_service.dart';
import 'package:safer/signup/signup_bloc/signup_event.dart';
import 'package:safer/signup/signup_bloc/signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthApiService authApiService;

  SignupBloc(this.authApiService) : super(SignupInitial()) {
    on<SignUpButtonPressed>(_signUpButtonPressed);
  }

  FutureOr<void> _signUpButtonPressed(SignUpButtonPressed event, Emitter<SignupState> emit) async {
    emit(SignupLoading());
    try {
      final response = await authApiService.signUp(event.email, event.password);
      print('SignUp Response : $response');

      final Map<String, dynamic> mapResponse = response;

      bool success = mapResponse['success'] == true;
      String message = mapResponse['message']?.toString() ?? 'Signup failed';

      if (success) {
        emit(SignupSuccess());
      } else {
        emit(SignupFailure(errorMsg: message));
      }
    } catch (e) {
      emit(SignupFailure(errorMsg: e.toString()));
    }
  }
}
