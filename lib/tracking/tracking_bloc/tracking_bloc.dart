import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safer/tracking/tracking_bloc/tracking_event.dart';
import 'package:safer/tracking/tracking_bloc/tracking_state.dart';
import '../location_model.dart';
import '../tracking_service.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final TrackingService trackingService;
  StreamSubscription<Position>? _positionSubscription;

  TrackingBloc({required this.trackingService}) : super(TrackingInitial()) {
    on<StartTracking>((event, emit) {
      _positionSubscription = trackingService.positionStream.listen((position) {
        add(LocationChanged(
          latitude: position.latitude,
          longitude: position.longitude,
        ));
      });
    });

    on<LocationChanged>((event, emit) async {
      emit(TrackingInProgress(
        latitude: event.latitude,
        longitude: event.longitude,
      ));

      final location = LocationModel(
        latitude: event.latitude,
        longitude: event.longitude,
        timestamp: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('locations')
          .add(location.toMap());
    });

    on<StopTracking>((event, emit) async {
      await _positionSubscription?.cancel();
      emit(TrackingStopped());
    });
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    return super.close();
  }
}
