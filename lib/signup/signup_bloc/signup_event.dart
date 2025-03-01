part of 'signup_bloc.dart';

@immutable
sealed class SignupEvent extends Equatable{
  const SignupEvent();

  @override
  List<Object?> get props => [];
}

class SignUpButtonPressed extends SignupEvent {
  final String email;
  final String password;

  const SignUpButtonPressed({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
