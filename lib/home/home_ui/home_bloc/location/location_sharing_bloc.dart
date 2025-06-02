import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';

part 'location_sharing_event.dart';
part 'location_sharing_state.dart';

class LocationSharingBloc extends Bloc<LocationSharingEvent, LocationSharingState> {
  final Telephony telephony = Telephony.instance;

  LocationSharingBloc() : super(LocationInitial()) {
    on<ShareLocationEvent>(_handleShareLocation);
  }

  FutureOr<void> _handleShareLocation(ShareLocationEvent event, Emitter<LocationSharingState> emit) async {
    emit(LocationSending());

    // Request permissions
    var locationStatus = await Permission.location.request();
    var smsStatus = await Permission.sms.request();

    if (!locationStatus.isGranted || !smsStatus.isGranted) {
      emit(LocationFailure("Required permissions not granted"));
      return;
    }

    try {
      // Get current position
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final locationUrl = 'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';

      for (final contact in event.selectedContacts) {
        if (contact.phones.isNotEmpty) {
          final number = contact.phones[0].number;
          await telephony.sendSms(
            to: number,
            message: "Emergency! My current location: $locationUrl",
          );
        }
      }

      emit(LocationSuccess());
    } catch (e) {
      emit(LocationFailure("Failed to send location: ${e.toString()}"));
    }
  }
}
