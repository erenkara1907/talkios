// ignore_for_file: unused_field

import 'dart:convert';
import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

class SoundRecorderService {
  FlutterSoundRecorder? _recorder;
  String? _currentPath;
  bool _isRecording = false;

  Future<void> init() async {
    _recorder = FlutterSoundRecorder();
    await startRecording();
  }

  Future<String?> startRecording() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    // _currentPath = await _recorder!.startRecorder(
    //   codec: Codec.pcm16WAV,
    // );
    _currentPath = "${appDocDirectory.path}/soundfile.wav";
    await _recorder!.openRecorder();
    await _recorder!.startRecorder(
      toFile: _currentPath,
    );
    _isRecording = true;
    return _currentPath;
  }

  Future<void> stopRecording() async {
    await _recorder!.stopRecorder();
    await _recorder!.closeRecorder();
    _isRecording = false;
    _recorder = null;
  }

  Future<String?> getBase64Recording() async {
    if (_currentPath != null) {
      final bytes = await File(_currentPath!).readAsBytes();
      return base64Encode(bytes);
    }
    return null;
  }

  void dispose() {
    _recorder!.closeRecorder();
    _recorder = null;
  }

  String? get currentPath => _currentPath;
}
