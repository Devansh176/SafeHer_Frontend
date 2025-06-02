part of 'location_sharing_bloc.dart';

abstract class LocationSharingState extends Equatable {
  const LocationSharingState();

  @override
  List<Object> get props => [];
}

class LocationInitial extends LocationSharingState {}

class LocationSending extends LocationSharingState {}

class LocationSuccess extends LocationSharingState {}

class LocationFailure extends LocationSharingState {
  final String message;

  const LocationFailure(this.message);

  @override
  List<Object> get props => [message];
}
