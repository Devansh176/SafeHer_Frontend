// import 'package:background_locator_2/background_locator.dart';
// import 'package:background_locator_2/location_dto.dart';
// import 'package:background_locator_2/settings/ios_settings.dart';
// import 'package:background_locator_2/settings/android_settings.dart';
// import 'package:background_locator_2/settings/locator_settings.dart';
//
// class TrackingService {
//   static LocationDto? _lastLocation;
//
//   static Future<void> initBackgroundTracking() async {
//     await BackgroundLocator.initialize();
//
//     await BackgroundLocator.registerLocationUpdate(
//       callback,
//       initCallback: initCallback,
//       disposeCallback: disposeCallback,
//       iosSettings: IOSSettings(
//         accuracy: LocationAccuracy.BALANCED,
//         distanceFilter: 10,
//       ),
//       androidSettings: AndroidSettings(
//         accuracy: LocationAccuracy.NAVIGATION,
//         interval: 10,
//         distanceFilter: 10,
//         androidNotificationSettings: AndroidNotificationSettings(
//           notificationChannelName: 'Location tracking',
//           notificationTitle: 'Tracking location',
//           notificationMsg: 'App is tracking your location in background',
//           notificationBigMsg: 'This app is using location service to ensure safety.',
//           notificationIcon: '',
//         ),
//       ),
//       autoStop: false,
//     );
//   }
//
//   static LocationDto? getLastLocation() => _lastLocation;
//
//   static Future<void> stopTracking() async {
//     await BackgroundLocator.unRegisterLocationUpdate();
//   }
// }
//
//
// void callback(LocationDto locationDto) async {
//   TrackingService._lastLocation = locationDto;
//   print("Background Location: ${locationDto.latitude}, ${locationDto.longitude}");
// }
//
// void initCallback(Map<String, dynamic> params) {
//   print("Background locator initialized");
// }
//
// void disposeCallback() {
//   print("Background locator disposed");
// }
