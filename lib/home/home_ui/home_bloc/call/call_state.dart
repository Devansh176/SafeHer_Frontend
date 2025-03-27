part of 'call_bloc.dart';

@immutable
sealed class CallState extends Equatable {
  @override
  List<Object> get props => [];
}

class CallInitial extends CallState {}
class CallLoading extends CallState {}
class CallSuccess extends CallState {}

class CallFailure extends CallState {
  final String errorMsg;
  CallFailure({required this.errorMsg});

  @override
  List<Object> get props => [errorMsg];
}
