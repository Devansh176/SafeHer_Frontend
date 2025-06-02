// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../tracking_service.dart';
// import 'tracking_event.dart';
// import 'tracking_state.dart';
//
// class LocationBloc extends Bloc<LocationEvent, LocationState> {
//   LocationBloc() : super(LocationInitial()) {
//     on<StartLocationTracking>((event, emit) async {
//       await TrackingService.initBackgroundTracking();
//       emit(LocationTrackingStarted());
//     });
//
//     on<StopLocationTracking>((event, emit) async {
//       await TrackingService.stopTracking();
//       emit(LocationTrackingStopped());
//     });
//
//     on<ShareLiveLocation>((event, emit) async {
//       final lastLocation = TrackingService.getLastLocation();
//       if (lastLocation != null) {
//         try {
//           await _shareWithEmergencyContacts(
//             lastLocation.latitude,
//             lastLocation.longitude,
//           );
//           emit(LocationSharedSuccess());
//         } catch (e) {
//           emit(LocationShareFailed(e.toString()));
//         }
//       } else {
//         emit(LocationShareFailed("No location available."));
//       }
//     });
//   }
//
//   Future<void> _shareWithEmergencyContacts(
//       double latitude, double longitude) async {
//     print("Sharing location to emergency contacts: $latitude, $longitude");
//
//   }
// }
