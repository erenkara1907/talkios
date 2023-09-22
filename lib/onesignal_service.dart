import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalService {
  static Future<void> setUpOneSignal() async {
    //Remove this method to stop OneSignal Debugging
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.initialize("f39507f2-14b0-4c40-8bd3-5f2cdccf27ee");

    // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.Notifications.requestPermission(true);
  }
}
