abstract class TrackingState {}

class TrackingInitial extends TrackingState {}

class TrackingInProgress extends TrackingState {
  final double latitude;
  final double longitude;

  TrackingInProgress({required this.latitude, required this.longitude});
}

class TrackingStopped extends TrackingState {}
