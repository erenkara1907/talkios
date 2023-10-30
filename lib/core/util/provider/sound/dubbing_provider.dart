// ignore_for_file: unused_local_variable, no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DubbingProvider with ChangeNotifier, WidgetsBindingObserver {
  // late AudioPlayer player;
  // late File audioFile;
  DubbingProvider() {
    initializeSpeechStatusListener();
    WidgetsBinding.instance.addObserver(this);
    // player = AudioPlayer();
  }

  int _messageIndex = -1;
  bool _isSpeaking = false;

  int get messageIndex => _messageIndex;
  bool get isSpeaking => _isSpeaking;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      stop();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // player.dispose();
    _speechStatusSubscription?.cancel();
    super.dispose();
  }

  // Future<void> speak(String text, int index, {required String gender}) async {
  //   try {
  //     //Load configs

  //     final voicesResponse = await AzureTts.getAvailableVoices();
  //     String _displayName = gender == "male" ? "Brian" : "Emma";
  //     final voice = voicesResponse.voices
  //         .firstWhere((element) => element.displayName == _displayName);

  //     TtsParams params = TtsParams(
  //       voice: voice,
  //       audioFormat: AudioOutputFormat.audio16khz32kBitrateMonoMp3,
  //       rate: 1.0,
  //       text: text,
  //     );

  //     final ttsResponse = await AzureTts.getTts(params);

  //     final audioBytes = ttsResponse.audio.buffer.asByteData();
  //     String dir = (await getApplicationDocumentsDirectory()).path;
  //     audioFile = File('$dir/audio.mp3');

  //     await audioFile.writeAsBytes(
  //       audioBytes.buffer.asUint8List(),
  //       flush: true,
  //     );

  //     if (await audioFile.exists()) {
  //       print(
  //           "File found: ${audioFile.path}, size: ${await audioFile.length()}");
  //     } else {
  //       print("File not found: ${audioFile.path}");
  //       return;
  //     }

  //     _isSpeaking = true;
  //     _messageIndex = index;
  //     notifyListeners();

  //     await player.play(DeviceFileSource(audioFile.path));
  //   } catch (e) {
  //     print("Something went wrong: $e");
  //   }
  // }

  // void stop() async {
  //   await player.stop();
  //   _isSpeaking = false;
  //   notifyListeners();
  // }

  final platform = const MethodChannel("text_to_speech");
  final _speechStatus = const EventChannel("speech_status");

  StreamSubscription? _speechStatusSubscription;

  void initializeSpeechStatusListener() {
    _speechStatusSubscription =
        _speechStatus.receiveBroadcastStream().listen((event) {
      if (event == "finished") {
        _isSpeaking = false;
        _messageIndex = -1;
        notifyListeners();
      }
    });
  }

  Future<void> speak(String text, int index) async {
    try {
      await platform.invokeMethod("speakText", {
        "text": text,
        "gender": "female",
      });
      _isSpeaking = true;
      _messageIndex = index;
      notifyListeners();
    } catch (e) {
      debugPrint("Error speaking text: $e");
      // TODO: Consider showing a SnackBar or another user feedback
    }
  }

  Future<void> stop() async {
    try {
      await platform.invokeMethod("stopText");
      _isSpeaking = false;
      notifyListeners();
    } catch (e) {
      debugPrint("Error stopping text: $e");
      // TODO: Consider showing a SnackBar or another user feedback
    }
  }
}
