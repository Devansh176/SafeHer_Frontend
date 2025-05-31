abstract class TrackingEvent {}

class StartTracking extends TrackingEvent {}

class StopTracking extends TrackingEvent {}

class LocationChanged extends TrackingEvent {
  final double latitude;
  final double longitude;

  LocationChanged({required this.latitude, required this.longitude});
}

