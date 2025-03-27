part of 'call_bloc.dart';

@immutable
sealed class CallEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CallRequest extends CallEvent {
  final String phoneNumber;

  CallRequest({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}
