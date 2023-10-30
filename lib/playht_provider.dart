import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
// import 'package:sse/client/sse_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:http/http.dart' as http;

class PlayHTProvider with ChangeNotifier {
  String? _url;
  Dio dio = Dio();
  bool _isLoading = false;

  String? get url => _url;
  bool get isLoading => _isLoading;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setUrl(String? url) {
    _url = url;
    notifyListeners();
  }

  AudioPlayer audioPlayer = AudioPlayer();

  Future<void> generateAudio(String text) async {
    _setLoading(true);
    SSEClient.subscribeToSSE(
      method: SSERequestType.POST,
      url: 'https://play.ht/api/v2/tts/stream',
      header: {
        'Authorization': '291a7031b5ae4b3898c15b21768b5553',
        'X-USER-ID': 'rDcUiGXravXNeG4xXp6gTdIcu6R2',
        'Accept': 'text/event-stream',
        'content-type': 'application/json',
        'Cache-Control': 'no-cache',
      },
      body: {
        'text': text,
        'output_format': 'mp3',
        "voice": "abram",
        'quality': 'draft',
        "voice_engine": 'PlayHT2.0'
      },
    ).listen((event) {
      print("data: ${event.data}");
      if (event.event == 'completed') {
        final data = jsonDecode(event.data!);
        final url = data['url'];
        _setLoading(false);
        _setUrl(url);
        playAudio(url);
      }
    });
  }

  Future<void> genersasateAudio(String text) async {
    try {
      _setLoading(true);
      final request = http.Request(
        'POST',
        Uri.parse('https://play.ht/api/v2/tts/stream'),
      )
        ..headers.addAll({
          'Authorization': '291a7031b5ae4b3898c15b21768b5553',
          'X-USER-ID': 'rDcUiGXravXNeG4xXp6gTdIcu6R2',
          'Accept': 'text/event-stream',
          'Content-Type': 'application/json',
        })
        ..body = jsonEncode({
          'text': text,
          'output_format': 'mp3',
          'quality': 'draft',
          "voice": "abram",
          "voice_engine": "PlayHT2.0"
        });

      final streamedResponse = await request.send();
      streamedResponse.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((line) {
        if (line.contains('event: completed')) {
          final dataLine = line
              .split('\n')
              .lastWhere((element) => element.startsWith('data:'));
          final data = jsonDecode(dataLine.substring(5));
          final url = data['url'];
          print("url : $url");
          _setUrl(url);
          playAudio(url);
          _setLoading(false);
        }
      });
    } catch (e) {
      print("hata : ${e.toString()}");
    }
  }

  void playAudio(String url) {
    audioPlayer.play(UrlSource(url));
  }
}
