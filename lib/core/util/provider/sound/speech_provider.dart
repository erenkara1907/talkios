// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechProvider with ChangeNotifier {
  SpeechToText speech = SpeechToText();
  String lastWords = "";

  bool _isRecord = false;
  bool get isRecord => _isRecord;

  bool _isVoiceRecording = false;
  bool get isVoiceRecording => _isVoiceRecording;

  void record(bool value) {
    _isRecord = value;
  }

  set isVoiceRecording(bool value) {
    _isVoiceRecording = value;
    notifyListeners();
  }

  Future<void> getPermissionAndStartListening(BuildContext context) async {
    await Permission.microphone.request();
    PermissionStatus permissionStatus = await Permission.microphone.status;

    if (permissionStatus.isGranted) {
      // startListening();
    } else {
      permissionStatus = await Permission.microphone.request();

      if (permissionStatus.isDenied) {
        // The user opted to never again see the permission request dialog for this
        // app. The only way to change the permission's status now is to let the
        // user manually enable it from the system settings.
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Microphone Permission Required'),
            content: const Text(
                'This app needs access to microphone. You can grant access in Settings.'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Open Settings'),
                onPressed: () {
                  Navigator.of(ctx, rootNavigator: true).pop();
                  openAppSettings();
                },
              ),
              ElevatedButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(ctx, rootNavigator: true).pop();
                },
              ),
            ],
          ),
        );
      } else {
        // You can request permission again.
        permissionStatus = await Permission.microphone.request();
      }

      if (permissionStatus.isGranted) {
        // startListening();
      } else {
        await Permission.microphone.request();
      }
    }
  }

  bool available = false;

  Future<void> initialize() async {
    available = await speech.initialize(
      onError: (val) => print('Error: $val'),
      onStatus: (val) => print('Status: $val'),
    );
  }

  Future<void> startListening() async {
    if (available) {
      await speech.listen(
        onResult: (val) {
          lastWords = val.recognizedWords;
          notifyListeners();
        },
      );
    } else {
      await speech.initialize(
        onError: (val) => print('Error: $val'),
        onStatus: (val) => print('Status: $val'),
      );
      await speech.listen(
        onResult: (val) {
          lastWords = val.recognizedWords;
          notifyListeners();
        },
      );
    }
  }

  void stopListening() {
    speech.stop();
    notifyListeners();
  }
}
