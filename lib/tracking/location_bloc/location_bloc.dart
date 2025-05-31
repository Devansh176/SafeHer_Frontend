import 'package:flutter_bloc/flutter_bloc.dart';
import '../tracking_service.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<StartLocationTracking>((event, emit) async {
      await TrackingService.initBackgroundTracking();
      emit(LocationTrackingStarted());
    });

    on<StopLocationTracking>((event, emit) async {
      await TrackingService.stopTracking();
      emit(LocationTrackingStopped());
    });

    on<ShareLiveLocation>((event, emit) async {
      final lastLocation = TrackingService.getLastLocation();
      if (lastLocation != null) {
        try {
          // 🔴 Replace this with your real emergency contacts sharing logic
          await _shareWithEmergencyContacts(
            lastLocation.latitude,
            lastLocation.longitude,
          );
          emit(LocationSharedSuccess());
        } catch (e) {
          emit(LocationShareFailed(e.toString()));
        }
      } else {
        emit(LocationShareFailed("No location available."));
      }
    });
  }

  Future<void> _shareWithEmergencyContacts(
      double latitude, double longitude) async {
    // 🟢 Send an HTTP request to your backend with the location + emergency contacts
    print("Sharing location to emergency contacts: $latitude, $longitude");

    // Example: send to Firebase or Spring Boot API
  }
}
