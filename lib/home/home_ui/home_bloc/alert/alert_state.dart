part of 'alert_bloc.dart';

@immutable
abstract class AlertState extends Equatable {
  const AlertState();

  @override
  List<Object?> get props => [];
}

class AlertInitial extends AlertState {}

class AlertLoading extends AlertState {}

class AlertLoaded extends AlertState {
  final List<Contact> selectedContacts;

  const AlertLoaded({required this.selectedContacts});

  @override
  List<Object?> get props => [selectedContacts];
}

class AlertError extends AlertState {
  final String errorMsg;

  const AlertError({required this.errorMsg});

  @override
  List<Object?> get props => [errorMsg];
}
