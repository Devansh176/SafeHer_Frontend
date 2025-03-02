import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
sealed class SignupState extends Equatable{
  const SignupState();

  @override
  List<Object?> get props => [];
}

final class SignupInitial extends SignupState {}

final class SignupLoading extends SignupState {}

final class SignupSuccess extends SignupState {}

final class SignupFailure extends SignupState {
  final String errorMsg;
  const SignupFailure({required this.errorMsg});

  @override
  List<Object?> get props => [errorMsg];
}
