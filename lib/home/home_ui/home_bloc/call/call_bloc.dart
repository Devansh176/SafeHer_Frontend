import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

part 'call_event.dart';
part 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  CallBloc() : super(CallInitial()) {
    on<CallRequest>(_handleCallRequest);
  }

  FutureOr<void> _handleCallRequest(CallRequest event, Emitter<CallState> emit) async {
    emit(CallLoading());

    var status = await Permission.phone.request();
    if (!status.isGranted) {
      emit(CallFailure(errorMsg: "Permission Denied"));
      return;
    }

    try {
      bool? directCallSuccess = await FlutterPhoneDirectCaller.callNumber(event.phoneNumber);

      if (directCallSuccess == true) {
        emit(CallSuccess());
      } else {
        final Uri callUri = Uri.parse("tel:${event.phoneNumber}");
        if (await canLaunchUrl(callUri)) {
          await launchUrl(callUri);
          emit(CallSuccess());
        } else {
          emit(CallFailure(errorMsg: "Could not launch dialer for ${event.phoneNumber}"));
        }
      }
    } catch (e) {
      emit(CallFailure(errorMsg: "Unexpected Error: ${e.toString()}"));
    }
  }
}
