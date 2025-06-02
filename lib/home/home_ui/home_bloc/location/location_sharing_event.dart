part of 'location_sharing_bloc.dart';

abstract class LocationSharingEvent extends Equatable {
  const LocationSharingEvent();

  @override
  List<Object> get props => [];
}

class ShareLocationEvent extends LocationSharingEvent {
  final List<Contact> selectedContacts;

  const ShareLocationEvent({required this.selectedContacts});

  @override
  List<Object> get props => [selectedContacts];
}
