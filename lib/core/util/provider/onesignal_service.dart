// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:talkios/core/cache/cache_manager.dart';
import 'package:talkios/core/enum/preference_keys.dart';

import '../../constant/api_constant.dart';

class OneSignalService {
  static Future<void> setUpOneSignal({
    required bool isUsageDuration,
    String? usageDuration,
  }) async {
    String? _playerId =
        CacheManager().getString(PreferencesKeys.PLAYER_ID.toString());
    String? _token = CacheManager().getString(PreferencesKeys.TOKEN.toString());

    if (_playerId == null || _playerId.isEmpty) {
      //Remove this method to stop OneSignal Debugging
      await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      OneSignal.initialize("ef5132ca-0d9a-438b-85e4-63a360dfe6a2");

      // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
      if (Platform.isIOS) {
        await OneSignal.Notifications.requestPermission(true);
      }

      String? _newPlayerId = OneSignal.User.pushSubscription.id;
      if (_newPlayerId != null &&
          _newPlayerId.isNotEmpty &&
          (_token != null && _token.isNotEmpty)) {
        await CacheManager()
            .setString(PreferencesKeys.PLAYER_ID.toString(), _newPlayerId);
        await sendOneSignalInfoToAPI(
          _newPlayerId,
          _token,
          isUsageDuration: isUsageDuration,
          usageDuration: usageDuration,
        );
      }
    } else {
      if (_playerId.isNotEmpty && (_token != null && _token.isNotEmpty)) {
        await sendOneSignalInfoToAPI(
          _playerId,
          _token,
          isUsageDuration: isUsageDuration,
          usageDuration: usageDuration,
        );
      }
    }
  }

  static Future<void> sendOneSignalInfoToAPI(String playerId, String token,
      {String? usageDuration, required bool isUsageDuration}) async {
    print("isUsage: $isUsageDuration");
    print("playerId: $playerId");
    final response = await http.post(
      Uri.parse(ApiConstant.instance.playerId),
      headers: {
        "Authorization": "Bearer $token",
      },
      body: isUsageDuration
          ? {
              'onesignal_player_id': playerId,
              'usage_duration': usageDuration,
            }
          : {
              'onesignal_player_id': playerId,
            },
    );

    if (response.statusCode == 200) {
      print('Player ID başarıyla gönderildi.');
    } else {
      print('Player ID gönderilirken bir hata oluştu: ${response.body}');
    }
  }
}
