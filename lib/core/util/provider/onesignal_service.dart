import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalService {
  static Future<void> setUpOneSignal() async {
    //Remove this method to stop OneSignal Debugging
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize("ef5132ca-0d9a-438b-85e4-63a360dfe6a2");

    // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.Notifications.requestPermission(true);
  }
}
