import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'share_event.dart';
part 'share_state.dart';

class ShareBloc extends Bloc<ShareEvent, ShareState> {
  ShareBloc() : super(ShareInitial()) {
    on<ShareEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
